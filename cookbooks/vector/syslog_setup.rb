# Create `/var/log/vector`:
%w( /var/log/vector ).each do |d|
  directory d do
    owner  'root'
    group  'root'
    mode   '0755'
  end
end

# Deploy `vector` configuration for `syslog`:
remote_file '/etc/vector/syslog.toml' do
  owner  'root'
  group  'root'
  mode   '644'

  notifies :restart, 'service[vector-syslog]'
end

# Deploy `systemd` configuration for `prometheus`:
remote_file '/etc/systemd/system/vector-syslog.service' do
  owner  'root'
  group  'root'
  mode   '644'

  notifies :restart, 'service[vector-syslog]'
end

# Service setting:
service 'vector-syslog' do
  action [ :enable, :restart ]
end

# Firewall settings here:
%w( 514/tcp ).each do |p|
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

# Depoy `consul` service configuration for `loki`:
template '/etc/consul.d/service-vector-syslog.json' do
  owner  'consul'
  group  'consul'
  mode   '644'

  variables(ipaddr: node['vector']['ipaddr'])

  notifies :reload, 'service[consul]'
end

service 'cosul' do
  action :nothing
end

template '/etc/promtail/syslog.yaml' do
  owner  'root'
  group  'root'
  mode   '644'

  variables(LOKIENDPOINT: node['promtail']['lokiendpoint'])

  notifies :restart, 'service[promtail-vector-syslog]'
end

# Deploy `systemd` configuration for `promtail-loki`:
remote_file '/etc/systemd/system/promtail-vector-syslog.service' do
  owner  'root'
  group  'root'
  mode   '644'
end

# Service setting:
service 'promtail-vector-syslog' do
  action [ :enable, :restart ]
end

# Deploy the `logrotated` configuration:
remote_file '/etc/logrotate.d/vector-syslog' do
  owner 'root'
  group 'root'
  mode '644'
end
