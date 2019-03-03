# Create a user for managing `wekan`:
user 'wekan' do
  home '/home/wekan'
  shell '/bin/bash'
  password '$6$saltsalt$OpVze2cUKNOKlStVplX0Rwi.W98E3y5kQ7Z22r6WHDEa3UIRovzVBUdv.ivlJAB1g9GRcdCAookz9f3PzZFDz0'
  create_home true
end

# SSH
directory '/home/wekan/.ssh' do
  owner 'wekan'
  group 'wekan'
  mode '700'
end

# Deploy `~/.ssh/.ssh/authorized_keys`:
encrypted_remote_file '/home/wekan/.ssh/authorized_keys' do
  owner 'wekan'
  group 'wekan'
  mode '600'
  source   'files/home/wekan/.ssh/authorized_keys'
  password ENV['ITAMAE_PASSWORD']
end
