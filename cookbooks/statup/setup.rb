# Make directory:
directory '/home/webadm/statup' do
  owner 'webadm'
  group 'webadm'
  mode '755'
end

# Deploy the configuration:
execute 'mc cp minio/backup/statup/config.yml /tmp/config.yml' do
  user 'kazu634'

  not_if "test -e #{node['statup']['config']}"
end

file '/tmp/config.yml' do
  owner 'webadm'
  group 'webadm'
  mode '664'

  not_if "test -e #{node['statup']['config']}"
end

execute "mv /tmp/config.yml #{node['statup']['config']}" do
  user 'webadm'

  not_if "test -e #{node['statup']['config']}"
end

# Deploy the configuration DB:
execute 'mc cp minio/backup/statup/statup.db /tmp/statup.db' do
  user 'kazu634'

  not_if "test -e #{node['statup']['db']}"
end

file '/tmp/statup.db' do
  owner 'webadm'
  group 'webadm'
  mode '664'

  not_if "test -e #{node['statup']['db']}"
end

execute "mv /tmp/statup.db #{node['statup']['db']}" do
  user 'webadm'

  not_if "test -e #{node['statup']['db']}"
end

# Deploy the supervisord configuration file:
remote_file '/etc/supervisor/conf.d/statup.conf' do
  user 'root'
  group 'root'
  mode '644'
end

# Apply the changes
execute 'Reload supervisor' do
  user 'root'

  command '/usr/bin/supervisorctl update'
end

# Firewall Setting:
%w( 8080/tcp ).each do |port|
  execute "ufw allow #{port}" do
    user 'root'

    not_if "LANG=c ufw status | grep #{port}"

    notifies :run, 'execute[ufw reload-or-enable]'
  end
end

execute 'ufw reload-or-enable' do
  user 'root'
  command 'LANG=C ufw reload | grep skipping && ufw --force enable || exit 0'

  action :nothing
end
