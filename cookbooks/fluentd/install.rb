# Load the APT key:
execute 'curl https://packages.treasuredata.com/GPG-KEY-td-agent | apt-key add -' do
  not_if 'apt-key list | grep Treasure'
end

# Deploy the APT source:
CMD = 'grep DISTRIB_CODENAME /etc/lsb-release | cut -f 2 -d "="'
DIST = run_command(CMD).stdout.chomp

template '/etc/apt/sources.list.d/treasure-data.list' do
  owner 'root'
  group 'root'
  mode '644'

  variables(platform: node['platform'], dist: DIST)
end

execute 'apt update' do
  action :run

  not_if 'which td-agent'
end

# Install
package 'td-agent' do
  action :install
end

# Overwrite the conf:
remote_file '/etc/td-agent/td-agent.conf' do
  owner node['td-agent']['user']
  group node['td-agent']['group']
  mode '644'
end

# Create /etc/td-agent/conf.d:
directory '/etc/td-agent/conf.d' do
  owner node['td-agent']['user']
  group node['td-agent']['group']
  mode '755'
end

# Deploy /etc/hosts file:
HOSTNAME = run_command('uname -n').stdout.chomp

template '/etc/hosts' do
  owner 'root'
  group 'root'
  mode '644'

  variables(HOSTNAME: HOSTNAME)
end

# Enable and start:
service 'td-agent' do
  action :enable
end
