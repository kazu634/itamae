#####################################
# Common Settings:
#####################################

include_recipe './attributes.rb'

include_recipe './prerequisites.rb'
include_recipe './install.rb'

include_recipe './setup.rb'

#####################################
# Manager Settings:
#####################################

if node['td-agent']['forward']
  include_recipe './processor.rb'
  include_recipe './syslog.rb'
  include_recipe './slack.rb'
end

#####################################
# monitoring Settings:
#####################################

include_recipe './nginx.rb'

%w( aptitude auth cron-apt monit consul ).each do |c|
  remote_file "/etc/td-agent/conf.d/forwarder_#{c}.conf" do
    owner 'root'
    group 'root'
    mode '644'

    notifies :restart, 'service[td-agent]'
  end
end

service 'td-agent' do
  action :restart
end
