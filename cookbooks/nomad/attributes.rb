# -------------------------------------------
# Specifying the default settings:
# -------------------------------------------
node.reverse_merge!({
  'nomad' => {
    'manager' => false,
    'client' => false
  }
})
