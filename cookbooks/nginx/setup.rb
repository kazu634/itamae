# Create the necessary directories:
%w( body fastcgi proxy scgi uwsgi ).each do |d|
  directory "/var/lib/nginx/#{d}" do
    owner 'www-data'
    group 'root'
    mode '755'
  end
end

%w( sites-available sites-enabled ).each do |d|
  directory "/etc/nginx/#{d}" do
    owner 'root'
    group 'root'
    mode '755'
  end
end

# Deploy the nginx configuration files:
remote_file '/etc/nginx/nginx.conf' do
  owner 'root'
  group 'root'
  mode '644'
  
  notifies :reload, 'service[nginx]'
end

%w( default maintenance ).each do |conf|
  remote_file "/etc/nginx/sites-available/#{conf}" do
    owner 'root'
    group 'root'
    mode '644'
  end
end

link '/etc/nginx/sites-enabled/default' do
  to '/etc/nginx/sites-available/default'

  notifies :reload, 'service[nginx]'
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