# Create User and group:
user 'prometheus' do
  system_user true
  shell '/sbin/nologin'
end

# Create `/etc/prometheus.d/`:
%w(/etc/prometheus.d).each do |d|
  directory d do
    owner  'prometheus'
    group  'promtheus'
    mode   '0755'
  end
end

# Deploy `prometheus` files:
remote_file '/etc/prometheus.d/prometheus.yml' do
  owner  'prometheus'
  group  'prometheus'
  mode   '644'
end

# Deploy `supervisor` configuration for `prometheus`:
remote_file '/etc/supervisor/conf.d/prometheus.conf' do
  owner  'prometheus'
  group  'prometheus'
  mode   '644'

  notifies :restart, 'service[supervisor]'
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
