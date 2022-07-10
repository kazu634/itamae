# Create directories
%w( certs howto misc policies tokens ).each do |d|
  directory "/etc/consul.d/#{d}" do
    owner 'consul'
    group 'consul'
    mode  '0755'
  end
end

# deploy certificates
if node['consul']['manager']
else
  encrypted_remote_file '/etc/consul.d/certs/consul-agent-ca.pem' do
    owner 'consul'
    group 'consul'
    mode '0444'

    source   'files/etc/consul.d/certs/consul-agent-ca.pem'
    password ENV['ITAMAE_PASSWORD']
  end
end

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
            encrypt: node['consul']['encrypt'],
            token: node['consul']['token'],
           )

  source "templates/etc/consul.d/#{SRC}"

  notifies :restart, 'service[consul]'
end

directory '/var/log/consul/' do
  owner 'consul'
  group 'consul'
  mode '0755'
end

remote_file '/etc/systemd/system/consul.service' do
  owner 'root'
  group 'root'
  mode '0644'

  notifies :restart, 'service[consul]'
end

remote_file '/etc/consul.d/service-consul.json' do
  owner 'consul'
  group 'consul'
  mode '644'
end

service 'consul' do
  action [:enable, :start]
end

# iptables settings here:
%w( 8300/tcp 8301/tcp 8301/udp 8500/tcp 8502/tcp ).each do |port|
  execute "ufw allow #{port}" do
    user 'root'

    not_if "LANG=c ufw status | grep #{port}"

    notifies :run, 'execute[ufw reload-or-enable]'
  end
end
