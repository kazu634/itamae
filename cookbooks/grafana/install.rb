# Deploy APT source file:
remote_file '/etc/apt/sources.list.d/grafana.list' do
  owner 'root'
  group 'root'
  mode '644'
end

# Load APT key:
execute 'curl https://packages.grafana.com/gpg.key | apt-key add -' do
  not_if 'apt-key list | grep grafana'
end

execute 'apt update'

package 'grafana' do
  action :install
end

