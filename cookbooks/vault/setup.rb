# Deploy `Vault` server config:
template '/etc/vault.d/vault.hcl' do
  owner 'vault'
  group 'vault'
  mode '644'

  variables(HOSTNAME: node['vault']['hostname'],  IPADDR: node['vault']['ipaddr'], IPS: node['vault']['ips'])
end

directory '/etc/vault.d/policies' do
  owner 'vault'
  group 'vault'
  mode '755'
end

%w( consul-auto-config consul-connect-vault ).each do |conf|
  remote_file "/etc/vault.d/policies/#{conf}.hcl" do
    owner 'vault'
    group 'vault'
    mode '644'
  end
end

remote_file '/etc/logrotate.d/vault' do
  owner 'root'
  group 'root'
  mode '644'
end
