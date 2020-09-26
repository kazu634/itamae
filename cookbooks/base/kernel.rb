STORAGE = '/etc/sysctl.d'

[
  "#{STORAGE}/90-vm-swappiness.conf",
  "#{STORAGE}/90-vfs-cache-pressure.conf",
  "#{STORAGE}/90-conntrack-tcp-timeout-time-wait.conf"
].each do |conf|
  remote_file conf do
    owner 'root'
    group 'root'
    mode '644'
  end
end
