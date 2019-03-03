# -------------------------------------------
# Specifying the default settings:
# -------------------------------------------
node.reverse_merge!({
  'td-agent' => {
    'user' => 'td-agent',
    'group' => 'td-agent',
    'forward' => false,
    'role' => 'primary'
  }
})
