# -------------------------------------------
# Specifying the default settings:
# -------------------------------------------
node.reverse_merge!({
  'loki' => {
    'url' => 'https://github.com/grafana/loki/releases/download/',
    'zip' => 'loki-linux-amd64.zip',
    'storage' => '/opt/loki/',
    'location' => '/usr/local/bin/'
  },
})
