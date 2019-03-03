# install `cifs-utils`
package 'cifs-utils'

directory '/mnt/backup/' do
  owner 'root'
  group 'root'
end

# Add the fstab entry:
file '/etc/fstab' do
  action :edit

  block do |content|
    content << "//192.168.10.200/Shared/backup /mnt/backup cifs username=admin,password=Holiday88,uid=root,gid=root,file_mode=0777,dir_mode=0777,defaults 0 0\n"
  end

  not_if 'grep backup /etc/fstab'
end

file '/etc/fstab' do
  action :edit

  block do |content|
    content << "//192.168.10.200/Shared/PXEBoot/www/ubuntu/apt-mirror /var/spool/apt-mirror cifs username=admin,password=Holiday88,uid=root,gid=root,file_mode=0777,dir_mode=0777,defaults 0 0\n"
  end

  not_if 'grep apt-mirror /etc/fstab'
end

execute 'mount -a'

# Deploy the cron.d file:
remote_file '/etc/cron.d/docker-housekeep' do
  owner 'root'
  group 'root'
  mode '644'
end
