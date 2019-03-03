# Deploy the `supervisord` configuration:
remote_file '/etc/supervisor/conf.d/node_exporter.conf' do
  owner 'root'
  group 'root'
  mode '644'

  notifies :restart, 'service[supervisor]'
end

service 'supervisor' do
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
