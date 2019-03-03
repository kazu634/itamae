STORAGE = '/etc/sysctl.d'

[
  "#{STORAGE}/90-vm-swappiness.conf",
  "#{STORAGE}/90-vfs-cache-pressure.conf"
].each do |conf|
  remote_file conf do
    owner 'root'
    group 'root'
    mode '644'
  end
end
