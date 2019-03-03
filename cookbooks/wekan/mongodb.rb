execute 'apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927' do
  not_if 'apt-key list | grep EA312927'
end

remote_file '/etc/apt/sources.list.d/mongodb-org.list' do
  user 'root'
  group 'root'
end

execute 'apt update' do
  not_if "apt show mongodb-org | grep Installed"
end

file '/etc/mongod.conf' do
  action :edit
  block do |content|
    content.gsub!(/127\.0\.0\.1/, node['wekan']['ipaddr'])
  end

  notifies :restart, 'service[mongod]'

  only_if 'grep 127.0.0.1 /etc/mongod.conf'
end

package 'mongodb-org' do
  action :install
end

service 'mongod' do
  action [ :enable, :start ]
end

[
  'echo "mongodb-org hold" | dpkg --set-selections',
  'echo "mongodb-org-server hold" | dpkg --set-selections',
  'echo "mongodb-org-shell hold" | dpkg --set-selections',
  'echo "mongodb-org-mongos hold" | dpkg --set-selections',
  'echo "mongodb-org-tools hold" | dpkg --set-selections'
].each do |cmd|
  execute cmd
end
