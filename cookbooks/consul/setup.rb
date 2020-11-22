if node['consul']['manager']
  SRC = 'consul-server.hcl.erb'
else
  SRC = 'consul-agent.hcl.erb'
end

template '/etc/consul.d/consul.hcl' do
  owner 'consul'
  group 'consul'
  mode '644'

  variables(manager: node['consul']['manager'],
            manager_hosts: node['consul']['manager_hosts'],
            ipaddr: node['consul']['ipaddr'],
           )

  source "templates/etc/consul.d/#{SRC}"
end

remote_file '/etc/consul.d/service-consul.json' do
  owner 'consul'
  group 'consul'
  mode '644'
end

# iptables settings here:
%w( 8300/tcp 8301/tcp 8301/udp 8500/tcp ).each do |port|
  execute "ufw allow #{port}" do
    user 'root'

    not_if "LANG=c ufw status | grep #{port}"

    notifies :run, 'execute[ufw reload-or-enable]'
  end
end
