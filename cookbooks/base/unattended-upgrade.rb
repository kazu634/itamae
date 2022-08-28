case run_command('grep VERSION_ID /etc/os-release | awk -F\" \'{print $2}\'').stdout.chomp
when "18.04"
  # Install `cron-apt`:
  package 'cron-apt'

  # From here, we are going to set up `cron-apt` to
  # install the important security updates every day.
  remote_file '/etc/cron-apt/config' do
    user 'root'

    owner 'root'
    group 'root'
    mode  '644'
  end

  remote_file '/etc/cron-apt/action.d/3-download' do
    user 'root'

    owner 'root'
    group 'root'
    mode '644'
  end

  execute 'grep security /etc/apt/sources.list > /etc/apt/security.sources.list' do
    user 'root'

    not_if 'test -e /etc/apt/security.sources.list'
  end

  file '/var/log/cron-apt/log' do
    user 'root'

    content 'foo\n'

    owner 'root'
    group 'root'
    mode '666'

    not_if 'test -e /var/log/cron-apt/log'
  end

  execute '/usr/sbin/logrotate -f /etc/logrotate.d/cron-apt' do
    user 'root'

    not_if 'test -e /var/log/cron-apt/log'
  end

when '20.04', '22.04'
  %w(20auto-upgrades 50unattended-upgrades).each do |conf|
    remote_file "/etc/apt/apt.conf.d/#{conf}" do
      owner 'root'
      group 'root'
      mode  '644'
    end
  end
end
