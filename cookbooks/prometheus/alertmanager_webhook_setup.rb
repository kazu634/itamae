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

