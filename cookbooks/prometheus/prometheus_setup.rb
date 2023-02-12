# Create User and group:
user 'prometheus' do
  system_user true
  shell '/sbin/nologin'
end

# Create `/etc/prometheus.d/`:
%w(/etc/prometheus.d).each do |d|
  directory d do
    owner  'prometheus'
    group  'prometheus'
    mode   '0755'
  end
end

# Deploy `prometheus` files:
remote_file '/etc/prometheus.d/prometheus.yml' do
  owner  'prometheus'
  group  'prometheus'
  mode   '644'
end

# Deploy `systemd` configuration for `prometheus`:
remote_file '/etc/systemd/system/prometheus.service' do
  owner  'root'
  group  'root'
  mode   '644'
end

service 'prometheus' do
  action [:enable, :start]
end

# Depoy `rsyslog` configuration for `prometheus`:
remote_file '/etc/rsyslog.d/30-prometheus.conf' do
  owner  'root'
  group  'root'
  mode   '644'

  notifies :restart, 'service[rsyslog]'
end

service 'rsyslog' do
  action :nothing
end

# Depoy `logrotate` configuration for `prometheus`:
remote_file '/etc/logrotate.d/prometheus' do
  owner  'root'
  group  'root'
  mode   '644'
end

# Depoy `vector` configuration for `prometheus`:
remote_file '/etc/vector/prometheus.toml' do
  owner  'root'
  group  'root'
  mode   '644'
end

# Depoy `consul` service configuration for `prometheus`:
remote_file '/etc/consul.d/service-prometheus.json' do
  owner  'consul'
  group  'consul'
  mode   '644'

  notifies :reload, 'service[consul]'
end

# Restart the `consul`:
service 'consul' do
  action :nothing
end

# Firewall settings here:
%w( 9090/tcp ).each do |p|
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
