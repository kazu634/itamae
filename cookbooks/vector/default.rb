# Loading the attributes:
include_recipe './attributes.rb'

# Install loki here:
include_recipe './install.rb'
include_recipe './setup.rb'

if node['vector']['isSyslog']
  include_recipe './syslog_setup.rb'
end
