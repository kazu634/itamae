# Deploy the `supervisord` configuration:
remote_file '/etc/systemd/system/node_exporter.service' do
  owner 'root'
  group 'root'
  mode '644'
end

remote_file '/etc/default/node_exporter' do
  owner 'root'
  group 'root'
  mode '644'
end

service 'node_exporter' do
  action [ :enable, :start]
end

# Deploy `rsyslog` config for `node_exporter`:
remote_file '/etc/rsyslog.d/30-node_exporter.conf' do
  owner 'root'
  group 'root'
  mode '644'

  notifies :restart, 'service[rsyslog]'
end

service 'rsyslog' do
  action :nothing
end

# Deploy `consul` config for `node_exporter`:
remote_file '/etc/consul.d/service-node_exporter.json' do
  owner 'consul'
  group 'consul'
  mode '644'

  notifies :reload, 'service[consul]'
end

service 'consul' do
  action :nothing
end

# Firewall settings here:
%w( 9100/tcp ).each do |p|
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
