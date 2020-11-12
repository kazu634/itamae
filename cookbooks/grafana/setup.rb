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
  mode '640'
end

%w(node_exporter.json node_exporter_all_nodes.json synology.json).each do |conf|
  remote_file "/var/lib/grafana/provision/dashboards/#{conf}" do
    owner 'grafana'
    group 'grafana'
    mode '640'
  end
end

# Start/Enable `grafana`:
service 'grafana-server' do
  action [ :enable, :start ]
end

# Deploy `consul` config for `grafana`:
remote_file '/etc/consul.d/service-grafana.json' do
  owner 'root'
  group 'root'
  mode '644'

  notifies :restart, 'service[supervisor]'
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
