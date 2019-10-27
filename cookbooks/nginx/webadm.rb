# Create a user for managing `nginx`:
user 'webadm' do
  home '/home/webadm'
  shell '/bin/bash'
  password '$1$lzfGward$TODNAMe9S9v.BXqpCV0p60'
  create_home true
end

# Deploy the `sudoers` file:
remote_file '/etc/sudoers.d/webadm' do
  owner 'root'
  group 'root'
  mode '440'
end

# Create `.ssh` directory:
directory '/home/webadm/.ssh' do
  owner 'webadm'
  group 'webadm'
  mode '700'
end

# Deploy `~/.ssh/.ssh/authorized_keys`:
encrypted_remote_file '/home/webadm/.ssh/authorized_keys' do
  owner 'webadm'
  group 'webadm'
  mode '600'
  source   'files/home/webadm/.ssh/authorized_keys'
  password ENV['ITAMAE_PASSWORD']
end

# Deploy secret keys
%w( id_rsa.github id_rsa.chef ).each do |conf|
  encrypted_remote_file "/home/webadm/.ssh/#{conf}" do
    owner 'webadm'
    group 'webadm'
    mode '600'
    source   "files/home/webadm/.ssh/#{conf}"
    password ENV['ITAMAE_PASSWORD']
  end
end
