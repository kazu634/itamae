# Create installation directory:
directory node['digdag']['install_path'] do
  owner 'root'
  group 'root'
  mode '755'
end

# Download and install:
URL = "#{node['digdag']['binary_url']}"
TARGET = "#{node['digdag']['install_path']}/digdag"

execute "wget #{URL} -O #{TARGET}" do
  not_if "test -e #{TARGET}"
end

file TARGET do
  owner 'root'
  group 'root'
  mode '755'
end

# Create link:
link '/usr/local/bin/digdag' do
  user 'root'
  to TARGET
end

# Install the Java Runtime:
%w(nkf default-jre).each do |p|
  package p do
    action :install
  end
end
