# Calculate the latest peco version:
wekan_url = ''
vtag = ''

begin
  require 'net/http'

  uri = URI.parse('https://github.com/wekan/wekan/releases/latest')

  Timeout.timeout(3) do
    response = Net::HTTP.get_response(uri)

    vtag = $1 if response.body =~ %r{tag\/v(\d+\.\d+)}

    wekan_url = "#{node['wekan']['url']}/wekan-#{vtag}.tar.gz"
  end
rescue
  # Abort the chef client process:
  raise 'Cannot connect to http://github.com.'
end

directory '/home/wekan/app' do
  owner 'wekan'
  group 'wekan'

  mode '755'
end

app_dir = "/home/wekan/app/#{vtag}"
directory app_dir do
  owner 'wekan'
  group 'wekan'

  mode '755'
end

tmp = "/tmp/wekan-#{vtag}.tar.gz"
execute "wget #{wekan_url} -O #{tmp}" do
  not_if "test -e #{app_dir}/bundle"
end

execute "tar xvzf #{tmp} -C /home/wekan/app/#{vtag}" do
  user 'wekan'

  not_if "test -e #{app_dir}/bundle"
end

template '/home/wekan/app/wekan.sh' do
  action :create
  owner 'wekan'
  group 'wekan'
  mode '744'

  variables(ipaddr: node['wekan']['ipaddr'], node_ver: node['nvm']['node_version'])

  notifies :restart, 'service[supervisor]'
end

template '/home/wekan/app/mongodb-backup.sh' do
  action :create
  owner 'wekan'
  group 'wekan'
  mode '744'

  variables(ipaddr: node['wekan']['ipaddr'])
end

link '/home/wekan/app/wekan' do
  to app_dir
  user 'wekan'
  force true
end

# Deploy the `supervisord` configuration:
remote_file '/etc/supervisor/conf.d/wekan.conf' do
  owner 'root'
  group 'root'
  mode '644'

  notifies :restart, 'service[supervisor]'
end

# Deploy the `conusl` service file:
remote_file '/etc/consul.d/service-wekan.json' do
  owner 'root'
  group 'root'
  mode '644'

  notifies :restart, 'service[supervisor]'
end

service 'supervisor' do
  action :nothing
end

# Firewall settings here:
%w( 3000/tcp ).each do |p|
  execute "ufw allow #{p}" do
    user 'root'

    not_if "LANG=c ufw status | grep #{p}"

    notifies :run, 'execute[ufw reload-or-enable]'
  end
end

execute 'ufw reload-or-enable' do
  user 'root'
  command 'LANG=C ufw reload | grep skipping && ufw --force enable || exit 0'

  action :nothing
end
