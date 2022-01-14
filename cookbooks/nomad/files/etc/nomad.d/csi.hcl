client {
  cni_path       = "/opt/cni/bin"
  cni_config_dir = "/etc/cni/"
}

plugin "docker" {
  config {
    volumes {
      enabled = true
    }

    allow_privileged = true
  }
}
