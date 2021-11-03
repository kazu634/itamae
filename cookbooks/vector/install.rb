KEY='https://repositories.timber.io/public/vector/gpg.3543DB2D0A2BC4B8.key'

execute "wget -O /tmp/vector.key #{KEY}" do
  not_if 'apt-key list | grep "1E46 C153"'
end

execute 'apt-key add /tmp/vector.key' do
  not_if 'apt-key list | grep "1E46 C153"'
end

# Retrieve the Ubuntu code:
DIST = run_command('lsb_release -cs').stdout.chomp

# Deploy the `apt` sources:
template '/etc/apt/sources.list.d/timber-vector.list' do
  action :create
  variables(distribution: DIST)
end

execute 'apt update'

package 'vector'
