# Install `Let's Encrypt`:
[
  'apt-get install -y software-properties-common',
  'add-apt-repository ppa:certbot/certbot -y',
  'apt-get update',
].each do |cmd|
  execute cmd do
    not_if 'which certbot'
  end
end

package 'certbot'

# Deploy the `let's Encrypt` renewal script:
%w( ssl_renewal.sh nginx-config.sh ).each do |s|
  remote_file "/home/webadm/bin/#{s}" do
    owner 'webadm'
    group 'webadm'
    mode '755'
  end
end

# Also for the renewal crontab configuration:
remote_file '/etc/cron.d/ssl' do
  owner 'root'
  group 'root'
  mode '644'
end
