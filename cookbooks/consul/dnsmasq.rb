package 'dnsmasq'

%w(dnsmasq resolvconf systemd-resolved).each do |s|
  service s do
    action :nothing
  end
end

case run_command('grep VERSION_ID /etc/os-release | awk -F\" \'{print $2}\'').stdout.chomp
when "20.04", "22.04"
  template '/etc/systemd/resolved.conf' do
    owner 'root'
    group 'root'
    mode '644'

    variables(dns: node['consul']['dns'])

    notifies :restart, 'service[systemd-resolved]', :immediately
  end

  remote_file '/etc/dnsmasq.conf' do
    owner 'root'
    group 'root'
    mode '644'

    source 'files/etc/dnsmasq.conf.2004'

    notifies :restart, 'service[dnsmasq]', :immediately
  end

when "18.04"
  remote_file '/etc/systemd/resolved.conf' do
    owner 'root'
    group 'root'
    mode '644'

    notifies :restart, 'service[systemd-resolved]'
  end

  remote_file '/etc/dnsmasq.conf' do
    owner 'root'
    group 'root'
    mode '644'

    source 'files/etc/dnsmasq.conf.1804'

    notifies :reload, 'service[dnsmasq]'
  end

when '16.04'
  remote_file '/etc/resolvconf/resolv.conf.d/head' do
    owner 'root'
    group 'root'
    mode '644'

    notifies :restart, 'service[resolvconf]'
  end

  remote_file '/etc/dnsmasq.conf' do
    owner 'root'
    group 'root'
    mode '644'

    source 'files/etc/dnsmasq.conf.1804'

    notifies :reload, 'service[dnsmasq]'
  end
end

