# -------------------------------------------
# Specifying the default settings:
# -------------------------------------------
node.reverse_merge!({
  'nginx' => {
    'version' => '1.23.2',
    'skip_lego' => 'false',
    'skip_webadm' => 'false'
  }
})
