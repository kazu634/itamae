# Create `/var/log/vector`:
%w( /var/log/vector ).each do |d|
  directory d do
    owner  'root'
    group  'root'
    mode   '0755'
  end
end

# Deploy config for `apt`:
remote_file '/etc/vector/apt.toml' do
  owner 'root'
  group 'root'
  mode  '0644'

  notifies :restart, 'service[vector-apt]'
end

remote_file '/etc/systemd/system/vector-apt.service' do
  owner 'root'
  group 'root'
  mode  '0644'

  notifies :restart, 'service[vector-apt]'
end

service 'vector-apt' do
  action [:enable, :start]
end

# Deploy config for mointoring `/var/log/auth.log`:
remote_file '/etc/vector/auth.toml' do
  owner 'root'
  group 'root'
  mode  '0644'

  notifies :restart, 'service[vector-auth]'
end

remote_file '/etc/systemd/system/vector-auth.service' do
  owner 'root'
  group 'root'
  mode  '0644'

  notifies :restart, 'service[vector-auth]'
end

service 'vector-auth' do
  action [:enable, :start]
end

# Deploy config for mointoring `/var/log/consul/consul-*.log`:
remote_file '/etc/vector/consul.toml' do
  owner 'root'
  group 'root'
  mode  '0644'

  notifies :restart, 'service[vector-consul]'
end

remote_file '/etc/systemd/system/vector-consul.service' do
  owner 'root'
  group 'root'
  mode  '0644'

  notifies :restart, 'service[vector-consul]'
end

service 'vector-consul' do
  action [:enable, :start]
end

# Deploy config for mointoring `journald`:
remote_file '/etc/vector/journald.toml' do
  owner 'root'
  group 'root'
  mode  '0644'

  notifies :restart, 'service[vector-journald]'
end

remote_file '/etc/systemd/system/vector-journald.service' do
  owner 'root'
  group 'root'
  mode  '0644'

  notifies :restart, 'service[vector-journald]'
end

service 'vector-journald' do
  action [:enable, :start]
end

# Deploy config for mointoring `/var/log/unattended-upgrades/unattended-upgrades-dpkg.log`:
remote_file '/etc/vector/unattended-upgrade.toml' do
  owner 'root'
  group 'root'
  mode  '0644'

  notifies :restart, 'service[vector-unattended-upgrade]'
end

remote_file '/etc/systemd/system/vector-unattended-upgrade.service' do
  owner 'root'
  group 'root'
  mode  '0644'

  notifies :restart, 'service[vector-unattended-upgrade]'
end

service 'vector-unattended-upgrade' do
  action [:enable, :start]
end

# Stop vector default service:
service 'vector' do
  action :disable
end
