include_recipe './attributes.rb'

include_recipe './install.rb'

include_recipe './consul-connect-prep.rb'
include_recipe './setup.rb'

include_recipe './dnsmasq.rb'
