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
%w(nkf openjdk-8-jdk).each do |p|
  package p do
    action :install
  end
end

execute 'update-java-alternatives -s java-1.8.0-openjdk-amd64' do
  user 'root'
end
