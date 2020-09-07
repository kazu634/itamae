# Create the necessary directories:
%w( body fastcgi proxy scgi uwsgi ).each do |d|
  directory "/var/lib/nginx/#{d}" do
    owner 'www-data'
    group 'root'
    mode '755'
  end
end

link '/etc/nginx/sites-enabled' do
  to '/home/webadm/repo/nginx-config/sites-available'
  user 'root'

  notifies :reload, 'service[nginx]'
end

link '/etc/nginx/stream-enabled' do
  to '/home/webadm/repo/nginx-config/stream-available'
  user 'root'

  notifies :reload, 'service[nginx]'
end

# Deploy the nginx configuration files:
%w(nginx.conf basic-auth).each do |f|
  remote_file "/etc/nginx/#{f}" do
    owner 'root'
    group 'root'
    mode '644'

    notifies :reload, 'service[nginx]'
  end
end

# Log rotation setting:
remote_file '/etc/logrotate.d/nginx' do
  owner 'root'
  group 'root'
  mode '644'
end

# Deploy the systemd file:
remote_file '/lib/systemd/system/nginx.service' do
  owner 'root'
  group 'root'
  mode '644'
end

# Firewall Setting:
%w( 80/tcp 443/tcp ).each do |port|
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

# Service setting:
service 'nginx' do
  action [ :enable, :start ]
end

# Deploy `promtail` config file:
HOSTNAME = run_command('uname -n').stdout.chomp

template '/etc/promtail/nginx.yaml' do
  owner 'root'
  group 'root'
  mode '644'

  variables(HOSTNAME: HOSTNAME, LOKIENDPOINT: node['promtail']['lokiendpoint'])
end

# Deploy the `systemd` configuration:
remote_file '/lib/systemd/system/promtail-nginx.service' do
  owner 'root'
  group 'root'
  mode '644'
end

# Service setting:
service 'promtail-nginx' do
  action [ :enable, :restart ]
end
