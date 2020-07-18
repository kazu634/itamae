# Create `/etc/prometheus.d/`:
%w(/etc/prometheus.d /etc/prometheus.d/targets/).each do |d|
  directory d do
    owner  'root'
    group  'root'
    mode   '0755'
  end
end

# Deploy `prometheus` files:
remote_file '/etc/prometheus.d/prometheus.yml' do
  owner  'root'
  group  'root'
  mode   '644'
end

# Deploy temporary file for `prometheus` targets:
remote_file '/etc/prometheus.d/targets/targets.yml' do
  owner  'root'
  group  'root'
  mode   '644'
end

# Deploy template file for `consul-template` generating `prometheus` target file:
remote_file '/etc/consul-template.d/prometheus-targets.tmpl' do
  owner  'root'
  group  'root'
  mode   '644'
end

# Deploy `supervisor` configuration for `prometheus-targets`, genarating `prometheus` targets:
remote_file '/etc/supervisor/conf.d/prometheus-targets.conf' do
  owner  'root'
  group  'root'
  mode   '644'

  notifies :restart, 'service[supervisor]'
end

# Deploy `supervisor` configuration for `prometheus`:
remote_file '/etc/supervisor/conf.d/prometheus.conf' do
  owner  'root'
  group  'root'
  mode   '644'

  notifies :restart, 'service[supervisor]'
end

# Depoy `consul` service configuration for `prometheus`:
remote_file '/etc/consul.d/service-prometheus.json' do
  owner  'root'
  group  'root'
  mode   '644'

  notifies :restart, 'service[supervisor]'
end

# Restart the `supervisor`:
service 'supervisor' do
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
