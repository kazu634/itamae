remote_file "/etc/letsencrypt/live/#{node['blog']['FQDN']}/dhparams_4096.pem" do
  owner 'root'
  group 'root'
end

execute "openssl rand 48 > /etc/letsencrypt/live/#{node['blog']['FQDN']}/ticket.key"
