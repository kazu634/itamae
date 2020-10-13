# Loading the attributes:
include_recipe './attributes.rb'

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

# Install the filestat_exporter here:
include_recipe './filestat_exporter_install.rb'
include_recipe './filestat_exporter_setup.rb'

include_recipe './exporter_proxy.rb'
