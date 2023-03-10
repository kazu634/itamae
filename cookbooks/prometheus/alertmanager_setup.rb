# Create `/etc/prometheus.d/alerts`:
%w(/etc/prometheus.d/alerts).each do |d|
  directory d do
    owner  'root'
    group  'root'
    mode   '0755'
  end
end

# Deploy `alertmanager` file:
remote_file '/etc/prometheus.d/alertmanager.yml' do
  owner  'root'
  group  'root'
  mode   '644'

  notifies :restart, 'service[supervisor]'
end

# Deploy alert setting file:
%w(node_exporter prometheus filestat).each do |conf|
  remote_file "/etc/prometheus.d/alerts/#{conf}.yml" do
    owner  'root'
    group  'root'
    mode   '644'

    notifies :restart, 'service[supervisor]'
  end
end

# Deploy `supervisord` config:
remote_file '/etc/supervisor/conf.d/alertmanager.conf' do
  owner  'root'
  group  'root'
  mode   '644'

  notifies :restart, 'service[supervisor]'
end

# Restart the `supervisor`:
service 'supervisor' do
  action :nothing
end

# Firewall settings here:
%w( 9093/tcp ).each do |p|
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
