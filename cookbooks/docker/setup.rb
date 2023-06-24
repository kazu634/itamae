# Ignore the certificate
directory '/etc/docker/' do
  owner 'root'
  group 'root'
  mode  '0600'
end

remote_file '/etc/docker/daemon.json' do
  owner 'root'
  group 'root'
  mode  '0600'

  notifies :restart, 'service[docker]'
end

# install `cifs-utils`
package 'cifs-utils'

%w( /mnt/shared /var/spool/apt-mirror ).each do |d|
  directory d do
    owner 'root'
    group 'root'
  end
end

# Add the fstab entry:
file '/etc/fstab' do
  action :edit

  block do |content|
    content << "//192.168.10.200/Shared/AppData /mnt/shared cifs username=admin,password=Holiday88,uid=root,gid=root,file_mode=0777,dir_mode=0777,vers=3.0,_netdev 0 0\n"
  end

  not_if 'grep shared /etc/fstab'
end

execute 'mount -a || true'

# Deploy the cron.d file:
remote_file '/etc/cron.d/docker-housekeep' do
  owner 'root'
  group 'root'
  mode '644'
end

# Deploy config file for `vector`:
template '/etc/vector/docker.toml' do
  owner 'root'
  group 'root'
  mode '644'

  variables(LOKI: node['docker']['loki'],
            HOSTNAME: node[:hostname]
           )

  source 'templates/etc/vector/docker.toml.erb'

  notifies :restart, 'service[vector-docker]'
end

# Deploy `systemd` configuration for `prometheus`:
remote_file '/etc/systemd/system/vector-docker.service' do
  owner  'root'
  group  'root'
  mode   '644'

  notifies :restart, 'service[vector-docker]'
end

# Service setting:
service 'vector-docker' do
  action [ :enable, :restart ]
end
