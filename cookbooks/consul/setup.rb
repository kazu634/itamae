remote_file '/etc/supervisor/conf.d/consul.conf' do
  owner 'root'
  group 'root'
  mode '644'
end

template '/etc/consul.d/config.json' do
  owner 'root'
  group 'root'
  mode '644'

  variables(manager: node['consul']['manager'],
            manager_hosts: node['consul']['manager_hosts'],
            ipaddr: node['consul']['ipaddr'],
           )

  notifies :restart, 'service[supervisor]'
end

remote_file '/etc/consul.d/service-consul.json' do
  owner 'root'
  group 'root'
  mode '644'

  only_if '{ node["consul"]["manager"]}'
end

execute 'Reload supervisor' do
  user 'root'

  command '/usr/bin/supervisorctl update'
end

# iptables settings here:
%w( 8300/tcp 8301/tcp 8301/udp 8500/tcp ).each do |port|
  execute "ufw allow #{port}" do
    user 'root'

    not_if "LANG=c ufw status | grep #{port}"

    notifies :run, 'execute[ufw reload-or-enable]'
  end
end
