# -------------------------------------------
# Specifying the default settings:
# -------------------------------------------
node.reverse_merge!({
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
  },
  'filestat_exporter' => {
    'url' => 'https://github.com/michael-doubez/filestat_exporter/releases/download/',
    'prefix' => 'filestat_exporter-',
    'postfix' => '.linux-amd64.tar.gz',
    'storage' => '/opt/filestat_exporter/',
    'location' => '/usr/local/bin/'
  },
})
