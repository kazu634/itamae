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

# Deploy `rsyslog` config:
remote_file '/etc/rsyslog.d/30-filestat_exporter.conf' do
  owner 'root'
  group 'root'
  mode '644'

  notifies :restart, 'service[rsyslog]'
end

service 'rsyslog' do
  action :nothing
end

# Deploy `logrotate` config:
remote_file '/etc/logrotate.d/filestat_exporter' do
  owner 'root'
  group 'root'
  mode '644'
end

# Deploy `vector` config:
remote_file '/etc/vector/filestat_exporter.toml' do
  owner 'root'
  group 'root'
  mode  '0644'

  notifies :restart, 'service[vector-filestat_exporter]'
end

remote_file '/etc/systemd/system/vector-filestat_exporter.service' do
  owner 'root'
  group 'root'
  mode  '0644'
end

service 'vector-filestat_exporter' do
  action [:enable, :start]
end

# Deploy `consul` config for `filestat_exporter`:
remote_file '/etc/consul.d/service-filestat_exporter.json' do
  owner 'consul'
  group 'consul'
  mode '644'

  notifies :reload, 'service[consul]'
end

service 'consul' do
  action :nothing
end
