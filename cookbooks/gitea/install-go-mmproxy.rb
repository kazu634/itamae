# Download:
TMP = "/tmp/go-mmproxy"

execute "wget #{node['go-mmproxy']['bin_url']} -O #{TMP}" do
  not_if "test -e #{node['go-mmproxy']['storage']}/go-mmproxy"
end

# Install:
directory node['go-mmproxy']['storage'] do
  owner 'root'
  group 'root'
  mode '755'
end

execute "mv #{TMP} #{node['go-mmproxy']['storage']}/go-mmproxy" do
  not_if "test -e #{node['go-mmproxy']['storage']}/go-mmproxy"
end

# Change Owner and Permissions:
file "#{node['go-mmproxy']['storage']}/go-mmproxy" do
  owner 'root'
  group 'root'
  mode  '755'
end

# Create Link
link "#{node['go-mmproxy']['location']}/go-mmproxy" do
  to "#{node['go-mmproxy']['storage']}/go-mmproxy"
end
