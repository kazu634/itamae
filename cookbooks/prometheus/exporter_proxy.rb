URL = 'https://github.com/rrreeeyyy/exporter_proxy/releases/download/v0.1.0/exporter_proxy_linux_amd64'
BIN = '/usr/local/bin/exporter_proxy'
CONFDIR = '/etc/exporter_proxy/'
CONF = 'config.yml'

execute "wget #{URL} -O #{BIN}" do
    not_if "test -e #{BIN}"
end

file BIN do
  user 'root'
  group 'root'

  mode '755'
end

directory CONFDIR do
  user 'root'
  group 'root'

  mode '755'
end

remote_file "#{CONFDIR}#{CONF}" do
  user 'root'
  group 'root'

  mode '644'
end

remote_file '/etc/supervisor/conf.d/exporter_proxy.conf' do
  user 'root'
  group 'root'

  mode '644'

  notifies :restart, 'service[supervisor]'
end

service 'supervisor' do
  action :nothing
end

# Firewall settings here:
%w( 9099/tcp ).each do |p|
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
