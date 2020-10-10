# ToDo: `iptables` setting must be here:
execute 'ufw allow 10022' do
  user 'root'

  not_if 'LANG=c ufw status | grep 10022'

  notifies :run, 'execute[ufw reload-or-enable]'
end

# Deploy the `sshd` configuration file:
case run_command('grep VERSION_ID /etc/os-release | awk -F\" \'{print $2}\'').stdout.chomp
when "20.04"
  remote_file '/etc/ssh/sshd_config' do
    user 'root'
    owner 'root'
    group 'root'
    mode '644'

    source 'files/etc/ssh/sshd_config.2004'
  end

when "18.04"
  remote_file '/etc/ssh/sshd_config' do
    user 'root'
    owner 'root'
    group 'root'
    mode '644'

    source 'files/etc/ssh/sshd_config.1804'
  end
else
  remote_file '/etc/ssh/sshd_config' do
    user 'root'
    owner 'root'
    group 'root'
    mode '644'
  end
end


# Apply the changes:
execute 'systemctl reload ssh.service ' do
  action :nothing
  subscribes :run, 'remote_file[/etc/ssh/sshd_config]'
end
