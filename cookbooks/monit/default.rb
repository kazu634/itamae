package 'monit'

service 'monit' do
  action :disable
end

case run_command('grep VERSION_ID /etc/os-release | awk -F\" \'{print $2}\'').stdout.chomp
when "18.04"
  # do nothing
else
  remote_file '/etc/monit/monitrc' do
    owner 'root'
    group 'root'
    mode '600'

    notifies :reload, 'service[monit]'
  end
end

remote_file '/etc/default/monit' do
  owner 'root'
  group 'root'
  mode '644'

  notifies :run, 'execute[systemctl daemon-reload]'
end

remote_file '/lib/systemd/system/monit.service' do
  owner 'root'
  group 'root'
  mode '644'

  notifies :run, 'execute[systemctl daemon-reload]'
end

execute 'systemctl daemon-reload' do
  action :nothing
  command '/etc/init.d/monit stop && systemctl daemon-reload && systemctl enable monit && systemctl start monit'
end
