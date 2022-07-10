auto_auth {
  method {
    type = "approle"

    config = {
      role_id_file_path = "/etc/vault.d/tokens/roleid"
      secret_id_file_path = "/etc/vault.d/tokens/secretid"
      remove_secret_id_file_after_reading = false
    }
  }

  sink {
    type = "file"

    config = {
      path = "/etc/consul-template.d/tokens/consul-jwt-vault-token"
    }
  }
}
