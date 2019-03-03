########################################################
# Common Configuration
########################################################

# Monit configuration for `td-agent`:
remote_file '/etc/monit/conf.d/td-agent.conf' do
  owner 'root'
  group 'root'
  mode '644'

  # notifies :restart, 'service[monit]'
end

# add `td-agent` user to `adm` group:
execute 'usermod -aG adm td-agent' do
  not_if 'id td-agent | grep adm'
end

# Deploy the `td-agent` configuration file for monitoring `td-agent` logs:
remote_file '/etc/td-agent/conf.d/forwarder_td-agent.conf' do
  owner 'root'
  group 'root'
  mode '644'
end

########################################################
# Agent Configuration:
########################################################
unless node['td-agent']['forward']
  remote_file '/etc/td-agent/conf.d/forwarder.conf' do
    owner 'root'
    group 'root'
    mode '644'
  end
end

########################################################
# Manager Configuration:
########################################################
if node['td-agent']['forward']
  remote_file '/etc/td-agent/conf.d/receiver.conf' do
    owner 'root'
    group 'root'
    mode '644'
  end

  template '/etc/consul.d/service-td-agent.json' do
    owner 'root'
    group 'root'
    mode '644'

    variables(role: node['td-agent']['role'])

    notifies :restart, 'service[supervisor]'
  end

  %w( 24224/tcp 24224/udp ).each do |p|
    execute "ufw allow #{p}" do
      user 'root'

      not_if "LANG=c ufw status | grep #{p}"

      notifies :run, 'execute[ufw reload-or-enable]'
    end
  end

  execute 'ufw reload-or-enable' do
    user 'root'
    command 'LANG=C ufw reload | grep skipping && ufw --force enable || exit 0'

    action :nothing
  end
end
