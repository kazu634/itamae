package 'cifs-utils'

%w(shared tmp img backup).each do |d|
  directory "/mnt/#{d}/" do
    owner 'root'
    group 'root'
    mode '777'
  end
end

directory '/var/spool/apt-mirror' do
  owner 'root'
  group 'root'
  mode '777'
end

# Add the fstab entry:
file '/etc/fstab' do
  action :edit

  block do |content|
    content << "//192.168.10.200/Shared/AppData /mnt/shared cifs username=admin,password=Holiday88,uid=root,gid=root,file_mode=0777,dir_mode=0777,vers=3.0,_netdev 0 0\n"
  end

  not_if 'grep shared /etc/fstab'
end

file '/etc/fstab' do
  action :edit

  block do |content|
    content << "//192.168.10.200/homes/kazu634/Photos/Moments /mnt/img cifs username=admin,password=Holiday88,uid=root,gid=root,file_mode=0777,dir_mode=0777,vers=3.0,_netdev 0 0\n"
  end

  not_if 'grep Moments /etc/fstab'
end

file '/etc/fstab' do
  action :edit

  block do |content|
    content << "//192.168.10.200/Shared/AppData /mnt/backup cifs username=admin,password=Holiday88,uid=root,gid=root,file_mode=0777,dir_mode=0777,vers=3.0,_netdev 0 0\n"
  end

  not_if 'grep backup /etc/fstab'
end

file '/etc/fstab' do
  action :edit

  block do |content|
    content << "//192.168.10.200/Shared/PXEBoot/www/ubuntu/apt-mirror /var/spool/apt-mirror cifs username=admin,password=Holiday88,uid=root,gid=root,file_mode=0777,dir_mode=0777,vers=3.0,_netdev 0 0\n"
  end

  not_if 'grep apt-mirror /etc/fstab'
end

execute 'mount -a || true' do
  not_if 'df -h | grep shared'
end
