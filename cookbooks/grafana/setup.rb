# Start provisioning:
%w(node_exporter.yaml node_exporter_all_nodes.yaml synology.yaml).each do |conf|
  remote_file "/etc/grafana/provisioning/dashboards/#{conf}" do
    owner 'root'
    group 'grafana'
    mode  '640'
  end
end

%w(loki.yaml prometheus.yaml).each do |conf|
  remote_file "/etc/grafana/provisioning/datasources/#{conf}" do
    owner 'root'
    group 'grafana'
    mode  '640'
  end
end

directory "/var/lib/grafana/provision/dashboards" do
  owner 'grafana'
  group 'grafana'
  mode '755'
end

%w(node_exporter.json node_exporter_all_nodes.json synology.json).each do |conf|
  remote_file "/var/lib/grafana/provision/dashboards/#{conf}" do
    owner 'grafana'
    group 'grafana'
    mode '640'
  end
end

remote_file '/etc/grafana/grafana.ini' do
  owner 'grafana'
  group 'grafana'
  mode '640'
end

# Start/Enable `grafana`:
service 'grafana-server' do
  action [ :enable, :start ]
end

# Deploy `consul` config for `grafana`:
remote_file '/etc/consul.d/service-grafana.json' do
  owner 'consul'
  group 'consul'
  mode '644'

  notifies :reload, 'service[consul]'
end

service 'consul' do
  action :nothing
end

# Firewall settings here:
%w( 3000/tcp ).each do |p|
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
