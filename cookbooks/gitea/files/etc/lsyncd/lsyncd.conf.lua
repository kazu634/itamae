settings {
  logfile = "/var/log/lsyncd/lsyncd.log",
  statusFile = "/var/log/lsyncd/lsyncd.status",
  statusInterval = 20,
  nodaemon   = false
}

sync {
  default.rsync,
  source = "/var/lib/git/",
  target = "admin@192.168.10.200:/volume1/Shared/AppData/gitea/git/",
  rsync      = {
    archive  = true,
    compress = true
  }
}

sync {
  default.rsync,
  source = "/var/lib/gitea/",
  target = "admin@192.168.10.200:/volume1/Shared/AppData/gitea/gitea-data/",
  rsync      = {
    archive  = true,
    compress = true
  }
}
