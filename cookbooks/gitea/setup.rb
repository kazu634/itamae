# Create `git` user:
user 'git' do
  create_home true
  home '/home/git/'

  system_user true

  shell '/bin/bash'
end

directory '/home/git/.ssh/' do
  owner 'git'
  group 'git'
  mode  '0700'
end

remote_file '/home/git/.ssh/authorized_keys' do
  owner 'git'
  group 'git'
  mode  '0600'
end

# Create `/etc/gitea/`:
%w(/etc/gitea).each do |d|
  directory d do
    owner  'root'
    group  'root'
    mode   '0755'
  end
end

%w(/var/lib/git /var/lib/gitea).each do |d|
  directory d do
    owner  'git'
    group  'git'
    mode   '0755'
  end
end

execute 'rsync -vrz --delete admin@192.168.10.200:/volume1/Shared/AppData/gitea/gitea-data/ /var/lib/gitea/' do
  not_if 'test -e /var/lib/gitea/log'
end

execute 'rsync -vrz --delete admin@192.168.10.200:/volume1/Shared/AppData/gitea/git/ /var/lib/git/' do
  not_if 'test -e /var/lib/git/kazu634/'
end

execute 'chown -R git:git /var/lib/gitea/'
execute 'chown -R git:git /var/lib/git/'

# Deploy `app.ini`:
remote_file '/etc/gitea/app.ini' do
  owner  'git'
  group  'git'
  mode   '644'
end

# Deploy `supervisord` config`:
remote_file '/etc/supervisor/conf.d/gitea.conf' do
  owner  'root'
  group  'root'
  mode   '644'

  notifies :restart, 'service[supervisor]'
end

service 'supervisor' do
  action :nothing
end

# Depoy `consul` service configuration for `gitea`:
remote_file '/etc/consul.d/service-gitea.json' do
  owner  'root'
  group  'root'
  mode   '644'

  notifies :restart, 'service[supervisor]'
end

# Depoy `promtail` configuration for `gitea`:
template '/etc/promtail/gitea.yaml' do
  owner  'root'
  group  'root'
  mode   '644'

  variables(HOSTNAME: node[:hostname], LOKIENDPOINT: node['promtail']['lokiendpoint'])

  notifies :restart, 'service[promtail-gitea]'
end

# Deploy `systemd` configuration for `promtail-gitea`:
remote_file '/etc/systemd/system/promtail-gitea.service' do
  owner  'root'
  group  'root'
  mode   '644'
end

# Service setting:
service 'promtail-gitea' do
  action [ :enable, :restart ]
end

# Deploy `systemd` configuration for `promtail-gitea`:
remote_file '/etc/lsyncd/lsyncd.conf.lua' do
  owner  'root'
  group  'root'
  mode   '644'
end

# Service setting:
service 'lsyncd' do
  action [ :enable, :restart ]
end

# Firewall settings here:
%w( 3000/tcp ).each do |p|
  execute "ufw allow #{p}" do
    user 'root'

    not_if "LANG=c ufw status | grep #{p}"

    notifies :run, 'execute[ufw reload-or-enable]'
  end
end

execute 'ufw reload-or-enable' do
  user 'root'
  command 'LANG=C ufw reload | grep skipping && ufw --force enable || exit 0'

  action :nothing
end
