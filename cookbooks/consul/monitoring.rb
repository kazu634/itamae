remote_file '/usr/local/bin/check_file' do
  owner 'root'
  group 'root'
  mode '755'
end

%w(reboot-required).each do |conf|
  remote_file "/etc/consul.d/check-#{conf}.json" do
    owner 'root'
    group 'root'
    mode '644'

    notifies :restart, 'service[supervisor]'
  end
end
