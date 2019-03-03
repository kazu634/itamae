package 'cifs-utils'

%w(shared tmp img).each do |d|
  directory "/mnt/#{d}/" do
    owner 'root'
    group 'root'
    mode '777'
  end
end

# Add the fstab entry:
file '/etc/fstab' do
  action :edit

  block do |content|
    content << "//192.168.10.200/Shared/shared /mnt/shared cifs username=admin,password=Holiday88,uid=root,gid=root,file_mode=0777,dir_mode=0777,defaults 0 0\n"
  end

  not_if 'grep shared /etc/fstab'
end

file '/etc/fstab' do
  action :edit

  block do |content|
    content << "//192.168.10.200/homes/kazu634/Drive/Moments /mnt/img cifs username=admin,password=Holiday88,uid=root,gid=root,file_mode=0777,dir_mode=0777,defaults 0 0\n"
  end

  not_if 'grep img /etc/fstab'
end

execute 'mount -a' do
  not_if 'df -h | grep shared'
end
