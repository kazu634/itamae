# -------------------------------------------
# Specifying the default settings:
# -------------------------------------------
node.reverse_merge!({
  'consulTemplate' => {
    'baseUrl' => 'https://releases.hashicorp.com/consul-template/',
    'version' => '0.25.2',
    'zipPrefix' => 'consul-template_',
    'zipPostfix' => '_linux_amd64.zip',
    'storage' => '/opt/consul-template/consul-template',
    'location' => '/usr/local/bin/consul-template'
  },
})
