job "countdash" {
  datacenters = ["dc1"]
  group "api" {
    network {
      mode = "bridge"

      port "envoy_metrics" {
        to = 9102
      }
    }

    service {
      name = "count-api"
      port = "9001"

      meta {
        envoy_metrics_port = "${NOMAD_HOST_PORT_envoy_metrics}"
      }

      connect {
        sidecar_service {
          proxy {
            config {
              envoy_prometheus_bind_addr = "0.0.0.0:9102"
            }
          }
          tags = ["envoy"]
        }
      }
    }

    task "web" {
      driver = "docker"
      config {
        image = "hashicorpnomad/counter-api:v1"
      }

      # constraint {
      #   attribute = "${attr.unique.hostname}"
      #   value     = "test01"
      # }
    }
  }

  group "dashboard" {
    network {
      mode ="bridge"
      port "http" {
        static = 9002
        to     = 9002
      }

      port "envoy_metrics" {
        to = 9102
      }
    }

    service {
      name = "count-dashboard"
      port = "9002"

      meta {
        envoy_metrics_port = "${NOMAD_HOST_PORT_envoy_metrics}"
      }

      connect {
        sidecar_service {
          proxy {
            upstreams {
              destination_name = "count-api"
              local_bind_port = 8080
            }
            config {
              envoy_prometheus_bind_addr = "0.0.0.0:9102"
            }
          }
          tags = ["envoy"]
        }
      }
    }

    task "dashboard" {
      driver = "docker"
      env {
        COUNTING_SERVICE_URL = "http://${NOMAD_UPSTREAM_ADDR_count_api}"
      }

      config {
        image = "hashicorpnomad/counter-dashboard:v1"
      }

      # constraint {
      #   attribute = "${attr.unique.hostname}"
      #  value     = "test03"
      # }
    }
  }
}
