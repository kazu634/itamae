# Install `Consul`:
KEYSRV = "https://apt.releases.hashicorp.com/gpg"
ID = "A3219F7B"

execute "apt-key adv --keyserver #{KEYSRV} --recv-keys #{ID}" do
  not_if 'apt-key list | grep HashiCorp'
end

# Retrieve the Ubuntu code:
DIST = run_command('lsb_release -cs').stdout.chomp

# Deploy the `apt` sources:
template '/etc/apt/sources.list.d/hashicorp.list' do
  action :create
  variables(distribution: DIST)
end

execute 'apt update' do
  not_if 'which vault'
end

package 'vault'
