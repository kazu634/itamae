# Create `/var/log/vector`:
%w( conf templates tokens ).each do |d|
  directory "/etc/consul-template.d/#{d}" do
    owner  'root'
    group  'root'
    mode   '0755'
  end
end

%w( /etc/systemd/system/consul-template.service /etc/default/consul-template).each do |conf|
  remote_file conf do
    owner 'root'
    group 'root'
    mode  '0644'

    notifies :run, 'execute[systemctl daemon-reload]', :immediately
  end
end

execute 'systemctl daemon-reload' do
  action :nothing
end

service 'consul-template' do
  action [:enable, :restart]
end

remote_file '/etc/rsyslog.d/30-consul-template.conf' do
  owner 'root'
  group 'root'
  mode  '0644'

  notifies :restart, 'service[rsyslog]', :immediately
end

remote_file '/etc/logrotate.d/consul-template' do
  owner 'root'
  group 'root'
  mode  '0644'
end

service 'rsyslog' do
  action [ :nothing ]
end

