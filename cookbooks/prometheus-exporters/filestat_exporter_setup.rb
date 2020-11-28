# Deploy the `supervisord` configuration:
remote_file '/etc/prometheus_exporters.d/filestat.yml' do
  owner 'root'
  group 'root'
  mode '644'

  notifies :restart, 'service[supervisor]'
end

# Deploy the `supervisord` configuration:
remote_file '/etc/supervisor/conf.d/filestat_exporter.conf' do
  owner 'root'
  group 'root'
  mode '644'

  notifies :restart, 'service[supervisor]'
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
