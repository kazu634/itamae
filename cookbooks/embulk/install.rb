# Create installation directory:
directory node['embulk']['install_path'] do
  owner 'root'
  group 'root'
  mode '755'
end

URL = "#{node['embulk']['base_binary_url']}#{node['embulk']['version']}#{node['embulk']['extension']}"
TARGET = "#{node['embulk']['install_path']}/embulk"

# Download and install:
execute "wget #{URL} -O #{TARGET}" do
  not_if "test -e #{TARGET}"
end

file TARGET do
  owner 'root'
  group 'root'
  mode '755'
end

# Create link:
link '/usr/local/bin/embulk' do
  user 'root'
  to TARGET
end

package 'default-jre' do
  action :install
end
