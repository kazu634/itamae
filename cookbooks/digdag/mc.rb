directory '/root/.mc' do
  owner 'root'
  group 'root'
  mode '700'
end

# Deploy the configuration file:
encrypted_remote_file '/root/.mc/config.json' do
  owner 'root'
  group 'root'
  mode '600'
  source   'files/root/.mc/config.json'
  password ENV['ITAMAE_PASSWORD']
end
