# Create `/etc/prometheus.d/alerts`:
%w(/etc/prometheus.d/alerts).each do |d|
  directory d do
    owner  'root'
    group  'root'
    mode   '0755'
  end
end

# Deploy `alertmanager` file:
encrypted_remote_file '/etc/prometheus.d/alertmanager.yml' do
  owner 'root'
  group 'root'
  mode  '644'

  source 'files/etc/prometheus.d/alertmanager.yml/'
  password ENV['ITAMAE_PASSWORD']

  notifies :restart, 'service[supervisor]'
end

# Deploy alert setting file:
%w(node_exporter prometheus filestat services snmp).each do |conf|
  remote_file "/etc/prometheus.d/alerts/#{conf}.yml" do
    owner  'root'
    group  'root'
    mode   '644'

    notifies :restart, 'service[supervisor]'
  end
end

# Deploy `systemd` config for `alertmanager`:
remote_file '/etc/systemd/system/alertmanager.service' do
  owner  'root'
  group  'root'
  mode   '644'
end

service 'alertmanager' do
  action [:enable, :start]
end

# Deploy `rsyslog` config for `alertmanager`:
remote_file '/etc/rsyslog.d/30-alertmanager.conf' do
  owner  'root'
  group  'root'
  mode   '644'

  notifies :restart, 'service[rsyslog]'
end

service 'rsyslog' do
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
