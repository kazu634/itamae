# Retrieve the default values:
include_recipe './attributes.rb'

# Kernel Parameters:
include_recipe './kernel.rb'

# Create the necessary directories:
%w( body fastcgi proxy scgi uwsgi ).each do |d|
  directory "/var/lib/nginx/#{d}" do
    owner 'www-data'
    group 'root'
    mode '755'
  end
end

%w( /etc/nginx/sites-enabled /etc/nginx/stream-enabled ).each do |d|
  directory d do
    owner 'root'
    group 'root'
    mode  '0755'
  end
end

# Deploy the nginx configuration files:
%w(nginx.conf basic-auth).each do |f|
  remote_file "/etc/nginx/#{f}" do
    owner 'root'
    group 'root'
    mode '644'

    notifies :reload, 'service[nginx]'
  end
end

# Prerequisites for Building nginx:
if node['nginx']['skip_webadm']
  include_recipe './webadm.rb'
end

# Install Let's Encrypt:
if node['nginx']['skip_lego']
  include_recipe './lego.rb'
end

# Build nginx:
include_recipe './build.rb'

# Setup nginx:
include_recipe './setup.rb'

