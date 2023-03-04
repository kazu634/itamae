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


# Stop vector default service:
service 'vector' do
  action :disable
end
