# Deploy APT source file:
remote_file '/etc/apt/sources.list.d/grafana.list' do
  owner 'root'
  group 'root'
  mode '644'
end

# Load APT key:
execute 'curl https://packagecloud.io/gpg.key | apt-key add -' do
  not_if 'apt-key list | grep packagecloud'
end

execute 'apt update'

package 'grafana' do
  action :install
end

