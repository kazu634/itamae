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
  },
  'alertmanager' => {
    'url' => 'https://github.com/prometheus/alertmanager/releases/download/',
    'prefix' => 'alertmanager-',
    'postfix' => '.linux-amd64.tar.gz',
    'storage' => '/opt/prometheus/',
    'location' => '/usr/local/bin/'
  },
  'alertmanager_webhook' => {
    'url' => 'https://github.com/tomtom-international/alertmanager-webhook-logger/releases/download/',
    'prefix' => 'alertmanager-webhook-logger-',
    'postfix' => '.zip',
    'storage' => '/opt/prometheus/',
    'location' => '/usr/local/bin/'
  },
  'filestat_exporter' => {
    'url' => 'https://github.com/michael-doubez/filestat_exporter/releases/download/',
    'prefix' => 'filestat_exporter-',
    'postfix' => '.linux-amd64.tar.gz',
    'storage' => '/opt/filestat_exporter/',
    'location' => '/usr/local/bin/'
  },
  'snmp_exporter' => {
    'url' => 'https://github.com/prometheus/snmp_exporter/releases/download/',
    'prefix' => 'snmp_exporter-',
    'postfix' => '.linux-amd64.tar.gz',
    'storage' => '/opt/snmp_exporter/',
    'location' => '/usr/local/bin/'
  },
})
