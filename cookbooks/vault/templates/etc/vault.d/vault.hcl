ui = true

disable_mlock = true

# service_registration "consul" {
#   address = "127.0.0.1:8500"
#   token = "19149728-ce09-2a72-26b6-d2fc3aeecdd8"
# }

storage "raft" {
  path    = "/opt/vault/data"
  node_id = "<%= @HOSTNAME %>"
<% @IPS.each do |ip| %>
  retry_join {
    leader_api_addr = "http://<%= ip %>:8200"
  }
<% end %>
}

api_addr = "http://<%= @IPADDR %>:8200"
cluster_addr = "http://<%= @IPADDR %>::8201"

# HTTPS listener
listener "tcp" {
  address       = "0.0.0.0:8200"
  cluster_address = "0.0.0.0:8201"

  tls_disable = true
  # tls_cert_file = "/opt/vault/tls/tls.crt"
  # tls_key_file  = "/opt/vault/tls/tls.key"
}
