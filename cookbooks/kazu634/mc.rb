directory '/home/kazu634/.mc' do
  owner 'kazu634'
  group 'kazu634'
  mode '700'
end

# Deploy the configuration file:
encrypted_remote_file '/home/kazu634/.mc/config.json' do
  owner 'kazu634'
  group 'kazu634'
  mode '600'
  source   'files/home/kazu634/.mc/config.json'
  password ENV['ITAMAE_PASSWORD']
end
