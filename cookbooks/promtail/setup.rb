# Deploy the configuration file:
%w( /etc/promtail /var/opt/promtail ).each do |d|
  directory d do
    owner 'root'
    group 'root'
    mode '755'
  end
end

# Deploy /etc/hosts file:
HOSTNAME = run_command('uname -n').stdout.chomp

template '/etc/promtail/base.yaml' do
  owner 'root'
  group 'root'
  mode '644'

  variables(HOSTNAME: HOSTNAME, LOKIENDPOINT: node['promtail']['lokiendpoint'])
end

# Deploy the `systemd` configuration:
remote_file '/lib/systemd/system/promtail-base.service' do
  owner 'root'
  group 'root'
  mode '644'
end

# Service setting:
service 'promtail-base' do
  action [ :enable, :restart ]
end

# Deploy the `systemd` configuration:
remote_file '/etc/rsyslog.d/30-promtail.conf' do
  owner 'root'
  group 'root'
  mode '644'

  notifies :restart, 'service[rsyslog]'
end

service 'rsyslog' do
  action [ :nothing ]
end

# Deploy the `logrotated` configuration:
remote_file '/etc/logrotate.d/promtail' do
  owner 'root'
  group 'root'
  mode '644'
end
