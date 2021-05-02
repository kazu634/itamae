# /etc/nomad.d/server.hcl

client {
  enabled          = true
}

plugin "docker" {
  config {
    volumes {
      enabled = true
    }
  }
}
