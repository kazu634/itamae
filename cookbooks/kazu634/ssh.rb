directory '/home/kazu634/.ssh' do
  owner 'kazu634'
  group 'kazu634'
  mode '700'
end

# Deploy `~/.ssh/.ssh/authorized_keys`:
encrypted_remote_file '/home/kazu634/.ssh/authorized_keys' do
  owner 'kazu634'
  group 'kazu634'
  mode '600'
  source   'files/home/kazu634/.ssh/authorized_keys'
  password ENV['ITAMAE_PASSWORD']
end

# Deploy secret keys
%w( id_rsa.github id_rsa.chef amazon.pem ).each do |conf|
  encrypted_remote_file "/home/kazu634/.ssh/#{conf}" do
    owner 'kazu634'
    group 'kazu634'
    mode '600'
    source   "files/home/kazu634/.ssh/#{conf}"
    password ENV['ITAMAE_PASSWORD']
  end
end

# Deploy .ssh/config:
remote_file '/home/kazu634/.ssh/config' do
  owner 'kazu634'
  group 'kazu634'
  mode '644'
end

