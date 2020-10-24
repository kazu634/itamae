# Create Link
link '/etc/prometheus_exporters.d/snmp.yml' do
  to "#{node['snmp_exporter']['storage']}snmp.yml"
end

# Deploy `supervisord` config:
remote_file '/etc/supervisor/conf.d/snmp_exporter.conf' do
  owner  'root'
  group  'root'
  mode   '644'

  notifies :restart, 'service[supervisor]'
end

# Deploy `consul` config:
remote_file '/etc/consul.d/service-snmp_exporter.json' do
  owner  'root'
  group  'root'
  mode   '644'

  notifies :restart, 'service[supervisor]'
end

# Restart the `supervisor`:
service 'supervisor' do
  action :nothing
end
