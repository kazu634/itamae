node_exporter_url = ''
node_exporter_bin = ''

tag               = ''
vtag              = ''

# Calculate the Download URL:
begin
  require 'net/http'

  uri = URI.parse('https://github.com/prometheus/node_exporter/releases/latest')

  Timeout.timeout(3) do
    response = Net::HTTP.get_response(uri)

    vtag = $1 if response.body =~ %r{tag\/(v\d+\.\d+\.\d+)}
    tag = vtag.sub(/^v/, '')

    node_exporter_bin = "#{node['node_exporter']['prefix']}#{tag}#{node['node_exporter']['postfix']}"
    node_exporter_url = "#{node['node_exporter']['url']}/#{vtag}/#{node_exporter_bin}"
  end
rescue
  # Abort the chef client process:
  raise 'Cannot connect to http://github.com.'
end

# バージョン確認して、アップデート必要かどうか確認
result = run_command("node_exporter --version 2>&1 | grep #{tag}", error: false)
if result.exit_status != 0
  # Download:
  TMP = "/tmp/#{node_exporter_bin}"

  execute "wget #{node_exporter_url} -O #{TMP}"

  # Install:
  directory node['node_exporter']['storage'] do
    owner 'root'
    group 'root'
    mode '755'
  end

  execute "tar zxf #{TMP} -C #{node['node_exporter']['storage']} --strip-components 1"

  # Change Owner and Permissions:
  file "#{node['node_exporter']['storage']}node_exporter" do
    owner 'root'
    group 'root'
    mode  '755'
  end

  # Create Link
  link "#{node['node_exporter']['location']}node_exporter" do
    to "#{node['node_exporter']['storage']}node_exporter"
  end
end
