[
  'rm -f /etc/nginx/sites-enabled/*',
  'ln -f -s /etc/nginx/sites-available/maintenance /etc/nginx/sites-enabled/maintenance',
  'systemctl reload nginx',
  "test -e /etc/letsencrypt/live/#{node['statup']['FQDN']}/cert.pem || certbot certonly --webroot -d #{node['statup']['FQDN']} --webroot-path /usr/share/nginx/html/ --email simoom634@yahoo.co.jp --agree-tos -n",
  '/home/webadm/bin/nginx-config.sh',
].each do |cmd|
  execute cmd
end

remote_file "/etc/letsencrypt/live/#{node['statup']['FQDN']}/dhparams_4096.pem" do
  owner 'root'
  group 'root'
  mode '644'
end

execute "openssl rand 48 > /etc/letsencrypt/live/#{node['statup']['FQDN']}/ticket.key"

remote_file '/etc/cron.d/statup' do
  user 'root'
  group 'root'
  mode '644'
end
