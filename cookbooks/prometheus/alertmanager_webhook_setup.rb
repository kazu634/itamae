# Deploy `supervisor` config for `Alert Manager Webhook Logger`
remote_file '/etc/supervisor/conf.d/alertmanager_webhook_logger.conf' do
  owner  'root'
  group  'root'
  mode   '644'

  notifies :restart, 'service[supervisor]'
end

# Restart the `supervisor`:
service 'supervisor' do
  action :nothing
end

