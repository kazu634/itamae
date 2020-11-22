# Create `/etc/loki/`:
%w(/etc/loki).each do |d|
  directory d do
    owner  'root'
    group  'root'
    mode   '0755'
  end
end

# Deploy `prometheus` files:
template '/etc/loki/loki-config.yml' do
  owner  'root'
  group  'root'
  mode   '644'

  variables(ipaddr: node['consul']['ipaddr'])

  notifies :restart, 'service[loki]'
end

# Deploy `systemd` configuration for `prometheus`:
remote_file '/etc/systemd/system/loki.service' do
  owner  'root'
  group  'root'
  mode   '644'
end

# Service setting:
service 'loki' do
  action [ :enable, :restart ]
end

# Depoy `consul` service configuration for `loki`:
template '/etc/consul.d/service-loki.json' do
  owner  'root'
  group  'root'
  mode   '644'

  variables(ipaddr: node['consul']['ipaddr'])

  notifies :reload, 'service[consul]'
end

service 'consul' do
  action :nothing
end

# Depoy `promtail` configuration for `loki`:
HOSTNAME = run_command('uname -n').stdout.chomp

template '/etc/promtail/loki.yaml' do
  owner  'root'
  group  'root'
  mode   '644'

  variables(HOSTNAME: HOSTNAME, LOKIENDPOINT: node['promtail']['lokiendpoint'])

  notifies :restart, 'service[promtail-loki]'
end

# Deploy `systemd` configuration for `promtail-loki`:
remote_file '/etc/systemd/system/promtail-loki.service' do
  owner  'root'
  group  'root'
  mode   '644'
end

# Service setting:
service 'promtail-loki' do
  action [ :enable, :restart ]
end

remote_file '/etc/rsyslog.d/30-loki.conf' do
  owner 'root'
  group 'root'
  mode '644'

  notifies :restart, 'service[rsyslog]'
end

service 'rsyslog' do
  action [ :nothing ]
end

# Deploy the `logrotated` configuration:
remote_file '/etc/logrotate.d/loki' do
  owner 'root'
  group 'root'
  mode '644'
end

# Restart the `supervisor`:
service 'supervisor' do
  action :nothing
end

# Firewall settings here:
%w( 3100/tcp ).each do |p|
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
