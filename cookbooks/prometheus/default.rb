# Loading the attributes:
include_recipe './attributes.rb'

# Install the Prometheus manager:
if node['prometheus']['manager']
  include_recipe './prometheus_install.rb'
  include_recipe './prometheus_setup.rb'

  include_recipe './alertmanager_install.rb'
  include_recipe './alertmanager_setup.rb'

  include_recipe './alertmanager_webhook_install.rb'
  include_recipe './alertmanager_webhook_setup.rb'

  # Deploy /etc/hosts file:
  HOSTNAME = run_command('uname -n').stdout.chomp

  template '/etc/promtail/prometheus.yaml' do
    owner 'root'
    group 'root'
    mode '644'

    variables(HOSTNAME: HOSTNAME, LOKIENDPOINT: node['promtail']['lokiendpoint'])

    notifies :restart, 'service[promtail-prometheus]'
  end

  # Deploy the `systemd` configuration:
  remote_file '/lib/systemd/system/promtail-prometheus.service' do
    owner 'root'
    group 'root'
    mode '644'
  end

  # Service setting:
  service 'promtail-prometheus' do
    action [ :enable, :restart ]
  end
end

# Create `/etc/prometheus.d/`:
%w(/etc/prometheus_exporters.d).each do |d|
  directory d do
    owner  'root'
    group  'root'
    mode   '0755'
  end
end

# Install the node_exporter here:
include_recipe './node_exporter_install.rb'
include_recipe './node_exporter_setup.rb'

include_recipe './exporter_proxy.rb'
