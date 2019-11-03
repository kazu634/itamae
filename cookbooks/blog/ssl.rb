remote_file "/etc/lego/dhparams_4096.pem" do
  owner 'root'
  group 'root'
  mode '444'
end

execute "openssl rand 48 > /etc/lego/ticket.key"

