# Create directory for digdag:
directory '/etc/digdag' do
  owner 'root'
  group 'root'
  mode '755'
end

# Deploy the files:
remote_file "/etc/digdag/digdag.sh" do
  owner 'root'
  group 'root'
  mode '755'
end

remote_file "/etc/digdag/digdag.config" do
  owner 'root'
  group 'root'
  mode '644'
end

# Firewall settings here:
%w( 65432/tcp ).each do |p|
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

# Deploy the config file for `systemd`:
remote_file '/lib/systemd/system/digdag.service' do
  owner 'root'
  group 'root'
  mode '644'
end

service 'digdag' do
  action [ :enable, :restart ]
end

# Deploy `rsyslog` config file for `digdag`:
remote_file '/etc/rsyslog.d/30-digdag.conf' do
  owner 'root'
  group 'root'
  mode '644'

  notifies :restart, 'service[rsyslog]', :immediately
end

# Deploy `logrotate` config for `digdag`:
remote_file '/etc/logrotate.d/digdag' do
  owner 'root'
  group 'root'
  mode '644'
end


# Deploy the config file for `vector`:
remote_file '/etc/vector/digdag.toml' do
  owner 'root'
  group 'root'
  mode  '644'
end

# Deploy the `systemd` configuration:
remote_file '/lib/systemd/system/vector-digdag.service' do
  owner 'root'
  group 'root'
  mode '644'
end

# Service setting:
service 'vector-digdag' do
  action [ :enable, :restart ]
end

service 'rsyslog' do
  action [ :nothing ]
end
