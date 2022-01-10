# Kernel parameters:
execute 'modprobe br_netfilter'

remote_file '/etc/sysctl.d/90-nomad.conf' do
  owner 'root'
  group 'root'
  mode '0644'
end

# nomad configuration files:
file '/etc/nomad.d/nomad.hcl' do
  action :delete
end

remote_file '/etc/nomad.d/datadir.hcl' do
  owner 'nomad'
  group 'nomad'
  mode '664'

  notifies :restart, 'service[nomad]'
end

if node['nomad']['manager']
  %w( server.hcl acl.hcl ).each do |conf|
    remote_file "/etc/nomad.d/#{conf}" do
      owner 'nomad'
      group 'nomad'
      mode '664'

      notifies :restart, 'service[nomad]'
    end
  end
end

if node['nomad']['client']
  %w( /etc/nomad.d/client.hcl /etc/nomad.d/docker-registry.hcl ).each do |conf|
    remote_file conf do
      owner 'nomad'
      group 'nomad'
      mode '664'

      notifies :restart, 'service[nomad]'
    end
  end
end

# Create directory:
directory '/opt/nomad/data/' do
  owner 'nomad'
  group 'nomad'
  mode '0755'
end

# iptables settings here:
%w( 80/tcp 4646/tcp 4647/tcp 4648/tcp 8081/tcp 20000:32000/tcp ).each do |port|
  execute "ufw allow #{port}" do
    user 'root'

    not_if "LANG=c ufw status | grep #{port}"

    notifies :run, 'execute[ufw reload-or-enable]'
  end
end

# Enable and start nomad:
service 'nomad' do
  action [:enable, :start]
end

# Deploy `promtail` config:
HOSTNAME = run_command('uname -n').stdout.chomp

template '/etc/promtail/nomad.yaml' do
  owner 'root'
  group 'root'
  mode '644'

  variables(HOSTNAME: HOSTNAME,  LOKIENDPOINT: node['nomad']['lokiendpoint'])

  notifies :restart, 'service[promtail-nomad]'
end

# Deploy the `systemd` configuration:
remote_file '/lib/systemd/system/promtail-nomad.service' do
  owner 'root'
  group 'root'
  mode '644'
end

# Service setting:
service 'promtail-nomad' do
  action [ :enable, :restart ]
end

remote_file '/etc/rsyslog.d/30-nomad.conf' do
  owner 'root'
  group 'root'
  mode '644'

  notifies :restart, 'service[rsyslog]'
end

service 'rsyslog' do
  action [ :nothing ]
end

# Deploy the `logrotated` configuration:
remote_file '/etc/logrotate.d/nomad' do
  owner 'root'
  group 'root'
  mode '644'
end
