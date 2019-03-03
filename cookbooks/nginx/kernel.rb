# kernel parameters:
%w( 90-nginx.conf ).each do |conf|
  remote_file "/etc/sysctl.d/#{conf}" do
    owner 'root'
    group 'root'

    mode '644'

    notifies :run, 'execute[sysctl -p /etc/sysctl.d/90-*.conf]'
  end
end

execute 'sysctl -p /etc/sysctl.d/90-*.conf' do
  action :nothing
end
