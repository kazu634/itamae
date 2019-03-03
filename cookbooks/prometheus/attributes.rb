# -------------------------------------------
# Specifying the default settings:
# -------------------------------------------
node.reverse_merge!({
  'prometheus' => {
    'manager' => false,
    'url' => 'https://github.com/prometheus/prometheus/releases/download/',
    'prefix' => 'prometheus-',
    'postfix' => '.linux-amd64.tar.gz',
    'storage' => '/opt/prometheus/',
    'location' => '/usr/local/bin/'
  },
  'node_exporter' => {
    'url' => 'https://github.com/prometheus/node_exporter/releases/download/',
    'prefix' => 'node_exporter-',
    'postfix' => '.linux-amd64.tar.gz',
    'storage' => '/opt/node_exporter/bin/',
    'location' => '/usr/local/bin/'
  },
  'blackbox_exporter' => {
    'url' => 'https://github.com/prometheus/blackbox_exporter/releases/download/',
    'prefix' => 'blackbox_exporter-',
    'postfix' => '.linux-amd64.tar.gz',
    'storage' => '/opt/blackbox_exporter/bin/',
    'location' => '/usr/local/bin/'
  }
})
