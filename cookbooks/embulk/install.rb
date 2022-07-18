# Create installation directory:
directory node['embulk']['install_path'] do
  owner 'root'
  group 'root'
  mode '755'
end

URL = "#{node['embulk']['base_binary_url']}#{node['embulk']['version']}/embulk-#{node['embulk']['version']}#{node['embulk']['extension']}"
TARGET = "#{node['embulk']['install_path']}/embulk"

# Download and install:
execute "wget #{URL} -O #{TARGET}"

file TARGET do
  owner 'root'
  group 'root'
  mode '755'
end

# Create link:
link '/usr/local/bin/embulk' do
  user 'root'
  to TARGET

  force true
end

case node['platform_version'].to_f
when 22.04
  package 'openjdk-8-jre' do
    action :install
  end
else
  package 'default-jre' do
    action :install
  end
end
