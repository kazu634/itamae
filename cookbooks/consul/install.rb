# -------------------------------------------
# Calculating the latest `consul` version:
# -------------------------------------------
download_url = ''

begin
  require 'net/http'

  uri = URI.parse('https://www.consul.io/downloads.html')

  Timeout.timeout(3) do
    response = Net::HTTP.get_response(uri)

    if response.body =~ /consul_(\d+\.\d+\.\d+)/
      tag_version = $1
      download_url = \
        "#{node['consul']['base_binary_url']}#{tag_version}/consul_#{tag_version}_linux_#{node['consul']['arch']}.zip"
    end
  end
rescue
  # Abort the chef client process:
  raise 'Cannot connect to https://www.consul.io/downloads.html'
end

# -------------------------------------------
# Main Part
# -------------------------------------------

# Download:
execute "wget #{download_url} -O #{node['consul']['tmp_path']}"

# Unzip:
execute "unzip -qo #{node['consul']['tmp_path']}" do
  cwd '/opt/consul/bin/'
end

file '/opt/consul/bin/consul' do
  owner 'root'
  group 'root'
  mode '755'
end

# Create link:
link '/usr/local/bin/consul' do
  user 'root'
  to '/opt/consul/bin/consul'
end
