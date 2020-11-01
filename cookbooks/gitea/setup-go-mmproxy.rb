# Deploy `supervisord` config`:
remote_file '/etc/systemd/system/go-mmproxy.service' do
  owner  'root'
  group  'root'
  mode   '644'

  notifies :restart, 'service[go-mmproxy]'
end

service 'go-mmproxy' do
  action [ :enable, :restart ]
end

# Depoy `consul` service configuration for `gitea`:
remote_file '/etc/consul.d/service-go-mmproxy.json' do
  owner  'root'
  group  'root'
  mode   '644'

  notifies :restart, 'service[supervisor]'
end

# Firewall settings here:
%w( 50021/tcp ).each do |p|
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