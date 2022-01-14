server {
  enabled          = true
  bootstrap_expect = 3
}

# data_dir tends to be environment specific.
data_dir = "/opt/nomad/data/"
