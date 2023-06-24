# Create the nginx directory:
%w( everun test-everun ).each do |d|
  directory "/var/www/#{d}" do
    owner 'www-data'
    group 'webadm'
    mode '770'
  end
end

# Add the fstab entry:
file '/etc/fstab' do
  action :edit

  block do |content|
    content << "tmpfs /var/www/everun tmpfs size=250m,noatime 0 0\n"
  end

  not_if 'grep /var/www/everun /etc/fstab'

  notifies :run, 'execute[mount -a]'
end

execute 'mount -a' do
  action :nothing
end

remote_file '/etc/cron.d/everun-blog' do
  owner 'root'
  group 'root'
  mode '644'
end

# Create storage directory for blog data
directory '/home/webadm/works/everun' do
  owner 'webadm'
  group 'webadm'
  mode '775'
end
