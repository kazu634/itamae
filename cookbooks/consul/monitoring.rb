package 'nagios-plugins' do
  action :install

  options '--no-install-recommends'
end

remote_file '/usr/lib/nagios/plugins/check_file' do
  owner 'root'
  group 'root'
  mode '555'

  notifies :restart, 'service[supervisor]'
end

# Deploy the check_memory script:
package 'bc' do
  action :install
end

URL = 'https://raw.githubusercontent.com/zwindler/check_mem_ng/master/check_mem_ng.sh'
TARGET = '/usr/lib/nagios/plugins/check_memory'

execute "wget #{URL} -O #{TARGET}" do
  not_if "test -e #{TARGET}"
end

file TARGET do
  owner 'root'
  group 'root'
  mode '755'
end

%w(disk load ssh swap reboot-required memory).each do |conf|
  remote_file "/etc/consul.d/check-#{conf}.json" do
    owner 'root'
    group 'root'
    mode '644'

    notifies :restart, 'service[supervisor]'
  end
end
