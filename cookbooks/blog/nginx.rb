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

remote_file '/etc/cron.d/blog' do
  owner 'root'
  group 'root'
  mode '644'
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

