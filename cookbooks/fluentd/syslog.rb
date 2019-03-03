%w( esxi synology vyos ).each do |c|
  remote_file "/etc/td-agent/conf.d/syslog_#{c}.conf" do
    owner 'root'
    group 'root'
    mode '644'
  end
end

%w( 1514/tcp 5140/tcp 5141/tcp ).each do |p|
  execute "ufw allow #{p}" do
    user 'root'

    not_if "LANG=c ufw status | grep #{p}"
  end
end
