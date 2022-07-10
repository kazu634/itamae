# Use Vault to retrieve the token to generate jwt.
%w( roleid secretid ).each do |f|
  encrypted_remote_file "/etc/vault.d/tokens/#{f}" do
    owner 'root'
    group 'root'
    mode '0644'

    source   "files/etc/vault.d/tokens/#{f}"
    password ENV['ITAMAE_PASSWORD']
  end
end

remote_file '/etc/vault.d/agent/consul-jwt.hcl' do
  owner 'vault'
  group 'vault'
  mode  '0644'

  notifies :restart, 'service[vault-agent-consul-jwt]'
end

remote_file '/etc/default/vault-agent-consul-jwt' do
  owner 'vault'
  group 'vault'
  mode '0644'
end

remote_file '/etc/systemd/system/vault-agent-consul-jwt.service' do
  owner 'root'
  group 'root'
  mode '0644'

  notifies :restart, 'service[vault-agent-consul-jwt]'
end

service 'vault-agent-consul-jwt' do
  action [:enable, :start]
end

# Use consul-template to retrieve the JWT token.
remote_file '/etc/consul-template.d/conf/consul-jwt.conf' do
  owner 'root'
  group 'root'
  mode '0644'

  notifies :restart, 'service[consul-template]'
end

remote_file '/etc/consul-template.d/templates/consul-jwt.tmpl' do
  owner 'root'
  group 'root'
  mode '0644'

  notifies :restart, 'service[consul-template]'
end
