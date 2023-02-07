# Deploy the `supervisord` configuration:
remote_file '/etc/prometheus_exporters.d/filestat.yml' do
  owner 'root'
  group 'root'
  mode '644'

  notifies :restart, 'service[supervisor]'
end

# Deploy the `systemd` configuration:
remote_file '/etc/systemd/system/filestat_exporter.service' do
  owner 'root'
  group 'root'
  mode '644'
end

service 'filestat_exporter' do
  action [:enable, :start]
end

# Deploy `consul` config for `node_exporter`:
remote_file '/etc/consul.d/service-filestat_exporter.json' do
  owner 'consul'
  group 'consul'
  mode '644'

  notifies :reload, 'service[consul]'
end

service 'consul' do
  action :nothing
end
