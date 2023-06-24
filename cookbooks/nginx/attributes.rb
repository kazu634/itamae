# -------------------------------------------
# Specifying the default settings:
# -------------------------------------------
node.reverse_merge!({
  'nginx' => {
    'version' => '1.25.0',
    'skip_lego' => 'true',
    'skip_webadm' => 'true'
  }
})
