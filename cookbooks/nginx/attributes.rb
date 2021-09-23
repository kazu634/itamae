# -------------------------------------------
# Specifying the default settings:
# -------------------------------------------
node.reverse_merge!({
  'nginx' => {
    'version' => '1.21.3',
    'skip_lego' => 'false',
    'skip_webadm' => 'false'
  }
})
