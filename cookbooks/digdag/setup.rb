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

# Deploy the config file for `supervisor`:
remote_file '/etc/supervisor/conf.d/digdag.conf' do
  owner 'root'
  group 'root'
  mode '644'

  notifies :restart, 'service[supervisor]'
end

service 'supervisor' do
  action :nothing
end
