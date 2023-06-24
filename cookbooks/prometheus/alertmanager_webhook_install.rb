alertmanager_webhook_url = ''
alertmanager_webhook_bin = ''

tag              = ''

# Calculate the Download URL:
begin
  require 'net/http'

  uri = URI.parse('https://github.com/tomtom-international/alertmanager-webhook-logger/releases/latest')

  Timeout.timeout(3) do
    response = Net::HTTP.get_response(uri)

    tag = $1 if response['location'] =~ %r{tag\/(\d+\.\d+)}

    alertmanager_webhook_bin = "#{node['alertmanager_webhook']['prefix']}#{tag}#{node['alertmanager_webhook']['postfix']}"

    alertmanager_webhook_url = "#{node['alertmanager_webhook']['url']}/#{tag}/#{alertmanager_webhook_bin}"
  end
rescue
  # Abort the chef client process:
  raise 'Cannot connect to http://github.com.'
end

# Download:
TMP = "/tmp/#{alertmanager_webhook_bin}"

execute "wget #{alertmanager_webhook_url} -O #{TMP}"

# Install:
directory node['alertmanager_webhook']['storage'] do
  owner 'root'
  group 'root'
  mode '755'
end

execute "unzip #{TMP} -d #{node['alertmanager_webhook']['storage']}" do
  not_if "test -e #{node['alertmanager_webhook']['storage']}alertmanager-webhook-logger"
end

# Change Owner and Permissions:
file "#{node['alertmanager_webhook']['storage']}alertmanager-webhook-logger" do
  owner 'root'
  group 'root'
  mode  '755'
end

# Create Link
link "#{node['alertmanager_webhook']['location']}alertmanager-webhook-logger" do
  to "#{node['alertmanager_webhook']['storage']}alertmanager-webhook-logger"
end
