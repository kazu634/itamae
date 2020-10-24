snmp_url = ''
snmp_bin = ''

vtag     = ''
tag      = ''

# Calculate the Download URL:
begin
  require 'net/http'

  uri = URI.parse('https://github.com/prometheus/snmp_exporter/releases/latest')

  Timeout.timeout(3) do
    response = Net::HTTP.get_response(uri)

    vtag = $1 if response.body =~ %r{tag\/(v\d+\.\d+\.\d+)}
    tag = vtag.sub(/^v/, '')

    snmp_bin = "#{node['snmp_exporter']['prefix']}#{tag}#{node['snmp_exporter']['postfix']}"

    snmp_url = "#{node['snmp_exporter']['url']}/#{vtag}/#{snmp_bin}"
  end
rescue
  # Abort the chef client process:
  raise 'Cannot connect to http://github.com.'
end

# Download:
TMP = "/tmp/#{snmp_bin}"

execute "wget #{snmp_url} -O #{TMP}"

# Install:
directory node['snmp_exporter']['storage'] do
  owner 'root'
  group 'root'
  mode '755'
end

execute "tar zxf #{TMP} -C #{node['snmp_exporter']['storage']} --strip-components 1"

# Change Owner and Permissions:
file "#{node['snmp_exporter']['storage']}snmp_exporter" do
  owner 'root'
  group 'root'
  mode  '755'
end

# Create Link
link "#{node['snmp_exporter']['location']}snmp_exporter" do
  to "#{node['snmp_exporter']['storage']}snmp_exporter"
end
