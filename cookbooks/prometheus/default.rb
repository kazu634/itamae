# Loading the attributes:
include_recipe './attributes.rb'

include_recipe './prometheus_install.rb'
include_recipe './prometheus_setup.rb'

include_recipe './alertmanager_install.rb'
include_recipe './alertmanager_setup.rb'

include_recipe './alertmanager_webhook_install.rb'
include_recipe './alertmanager_webhook_setup.rb'

include_recipe './snmp_exporter_install.rb'
include_recipe './snmp_exporter_setup.rb'
