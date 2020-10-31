include_recipe '../cookbooks/prometheus/default.rb'
include_recipe '../cookbooks/grafana/default.rb'
include_recipe '../cookbooks/loki/default.rb'
include_recipe '../cookbooks/vector/syslog_setup.rb'
