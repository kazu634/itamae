# Deploy the nginx configuration file:
remote_file '/etc/nginx/sites-available/blog' do
  owner 'root'
  group 'root'
  mode '644'
end

# Deploy cron tab configuration for nginx
remote_file '/etc/cron.d/blog' do
  owner 'root'
  group 'root'
  mode '644'
end

# Create link:
link '/etc/nginx/sites-enabled/blog' do
  user 'root'
  to '/etc/nginx/sites-available/blog'

  notifies :restart, 'service[nginx]'
end

service 'nginx' do
  action :nothing
end

# Create the nginx directory:
directory '/var/www/blog' do
  owner 'www-data'
  group 'webadm'
  mode '770'
end

# Add the fstab entry:
file '/etc/fstab' do
  action :edit

  block do |content|
    content << "tmpfs /var/www/blog tmpfs size=250m,noatime 0 0\n"
  end

  not_if 'grep /var/www/blog /etc/fstab'

  notifies :run, 'execute[fstab -a]'
end

execute 'mount -a' do
  action :nothing
end

# Add monit configuration file for monitoring nginx logs:
remote_file '/etc/monit/conf.d/blog-log.conf' do
  owner 'root'
  group 'root'
  mode '644'

  notifies :reload, 'service[monit]'
end

service 'monit' do
  action :nothing
end

