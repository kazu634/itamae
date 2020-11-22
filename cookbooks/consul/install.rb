# Install `Consul`:
KEYSRV = "https://apt.releases.hashicorp.com/gpg"
ID = "A3219F7B"

execute "apt-key adv --keyserver #{KEYSRV} --recv-keys #{ID}" do
  not_if "apt-key list | grep #{ID}"
end

# Retrieve the Ubuntu code:
DIST = run_command('lsb_release -cs').stdout.chomp

# Deploy the `apt` sources:
template '/etc/apt/sources.list.d/consul.list' do
  action :create
  variables(distribution: DIST)
end

execute 'apt update'

package 'consul'
