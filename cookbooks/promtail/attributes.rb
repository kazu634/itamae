# -------------------------------------------
# Specifying the default settings:
# -------------------------------------------
node.reverse_merge!({
  'promtail' => {
    'url' => 'https://github.com/grafana/loki/releases/download/',
    'bin' => 'promtail-linux-amd64.zip',
    'storage' => '/opt/promtail/bin/',
    'location' => '/usr/local/bin/',
    'data' => '/var/opt/promtail/',
    'lokiendpoint' => 'loki.service.consul:3100'
  },
})

