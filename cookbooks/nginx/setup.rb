# Log rotation setting:
remote_file '/etc/logrotate.d/nginx' do
  owner 'root'
  group 'root'
  mode '644'
end

# Deploy the systemd file:
remote_file '/lib/systemd/system/nginx.service' do
  owner 'root'
  group 'root'
  mode '644'
end

# Firewall Setting:
%w( 80/tcp 443/tcp 443/udp ).each do |port|
  execute "ufw allow #{port}" do
    user 'root'

    not_if "LANG=c ufw status | grep #{port}"

    notifies :run, 'execute[ufw reload-or-enable]'
  end
end

execute 'ufw reload-or-enable' do
  user 'root'
  command 'LANG=C ufw reload | grep skipping && ufw --force enable || exit 0'

  action :nothing
end

# Service setting:
service 'nginx' do
  action [ :enable, :start ]
end

# Deploy `vector` config:
remote_file '/etc/vector/nginx-access.toml' do
  owner 'root'
  group 'root'
  mode '644'
end

remote_file '/etc/systemd/system/vector-nginx-access.service' do
  owner 'root'
  group 'root'
  mode '644'
end

service 'vector-nginx-access' do
  action [ :enable, :start ]
end

remote_file '/etc/vector/nginx-error.toml' do
  owner 'root'
  group 'root'
  mode '644'
end

remote_file '/etc/systemd/system/vector-nginx-error.service' do
  owner 'root'
  group 'root'
  mode '644'
end

service 'vector-nginx-error' do
  action [ :enable, :start ]
end

