# -------------------------------------------
# Specifying the default settings:
# -------------------------------------------
node.reverse_merge!({
  'nomad' => {
    'manager' => false,
    'client' => false,
    'lokiendpoint' => 'loki.service.consul:3100',
    'synology' => '192.168.10.200'
  }
})
