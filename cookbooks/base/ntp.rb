package 'ntp'

remote_file '/etc/ntp.conf' do
  owner 'root'
  group 'root'
  mode '644'

  notifies :restart, 'service[ntp]'
end

service 'ntp' do
  action :nothing
end
