# -------------------------------------------
# Specifying the default settings:
# -------------------------------------------
node.reverse_merge!({
  'consul-template' => {
    'base_binary_url' => 'https://releases.hashicorp.com/consul-template/',
    'arch' => node['kernel']['machine'] =~ /x86_64/ ? 'amd64' : '386',
    'tmp_path' => '/tmp/itamae_tmp/consul-template.zip'
  }
})
