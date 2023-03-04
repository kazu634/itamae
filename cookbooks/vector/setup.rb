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

# Stop vector default service:
service 'vector' do
  action :disable
end
