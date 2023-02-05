# Create Link
link '/etc/prometheus_exporters.d/snmp.yml' do
  to "#{node['snmp_exporter']['storage']}snmp.yml"
end

# Deploy `systemd` config:
remote_file '/etc/systemd/system/snmp_exporter.service' do
  owner  'root'
  group  'root'
  mode   '644'
end

service 'snmp_exporter' do
  action [:enable, :start]
end

# Deploy `consul` config:
remote_file '/etc/consul.d/service-snmp_exporter.json' do
  owner  'consul'
  group  'consul'
  mode   '644'

  notifies :reload, 'service[consul]'
end

# Restart the `reload`:
service 'consul' do
  action :nothing
end

# Deploy /etc/hosts file:
template '/etc/promtail/snmp_exporter.yaml' do
  owner 'root'
  group 'root'
  mode '644'

  variables(HOSTNAME: node[:hostname], LOKIENDPOINT: node['promtail']['lokiendpoint'])

  notifies :restart, 'service[promtail-snmp_exporter]'
end

# Deploy the `systemd` configuration:
remote_file '/lib/systemd/system/promtail-snmp_exporter.service' do
  owner 'root'
  group 'root'
  mode '644'
end

# Service setting:
service 'promtail-snmp_exporter' do
  action [ :enable, :restart ]
end
