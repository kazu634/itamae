client {
  host_volume "docker-registry" {
    path      = "/mnt/shared/Docker-registry"
    read_only = false
  }
}
