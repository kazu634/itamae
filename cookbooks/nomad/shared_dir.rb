%w( /mnt/shared ).each do |d|
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
