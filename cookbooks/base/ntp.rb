case run_command('grep VERSION_ID /etc/os-release | awk -F\" \'{print $2}\'').stdout.chomp
when "18.04"
  # do nothing
else
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
end
