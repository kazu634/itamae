# Deploy `systemd` config for `Alert Manager Webhook Logger`
remote_file '/etc/systemd/system.d/webhook.conf' do
  owner  'root'
  group  'root'
  mode   '644'

  notifies :restart, 'service[webhook]'
end

service 'webhook' do
  action [:enable, :start]
end

# Deploy `rsyslog` config for `Alert Manager Webhook Logger`:
remote_file '/etc/rsyslog.d/30-webhook.conf' do
  owner 'root'
  group 'root'
  mode  '0644'

  notifies :restart, 'service[rsyslog]'
end

service 'rsyslog' do
  action :nothing
end
