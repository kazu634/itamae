# Loading the attributes:
include_recipe './attributes.rb'

# Install the Prometheus manager:
if node['prometheus']['manager']
  include_recipe './install.rb'
  include_recipe './setup.rb'
end

# Install the node_exporter here:
include_recipe './node_exporter_install.rb'
include_recipe './node_exporter_setup.rb'

include_recipe './exporter_proxy.rb'
