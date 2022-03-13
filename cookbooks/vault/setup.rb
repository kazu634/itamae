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
