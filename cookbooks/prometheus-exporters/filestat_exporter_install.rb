filestat_exporter_url = ''
filestat_exporter_bin = ''

vtag              = ''

# Calculate the Download URL:
begin
  require 'net/http'

  uri = URI.parse('https://github.com/michael-doubez/filestat_exporter/releases/latest')

  Timeout.timeout(3) do
    response = Net::HTTP.get_response(uri)

    vtag = $1 if response['location'] =~ %r{tag\/(v\d+\.\d+\.\d+)}

    filestat_exporter_bin = "#{node['filestat_exporter']['prefix']}#{vtag}#{node['filestat_exporter']['postfix']}"
    filestat_exporter_url = "#{node['filestat_exporter']['url']}/#{vtag}/#{filestat_exporter_bin}"
  end
rescue
  # Abort the chef client process:
  raise 'Cannot connect to http://github.com.'
end

# バージョン確認して、アップデート必要かどうか確認
result = run_command("filestat_exporter --version 2>&1 | grep #{vtag}", error: false)
if result.exit_status != 0
  # Download:
  TMP = "/tmp/#{filestat_exporter_bin}"

  execute "wget #{filestat_exporter_url} -O #{TMP}"

  # Install:
  directory node['filestat_exporter']['storage'] do
    owner 'root'
    group 'root'
    mode '755'
  end

  execute "tar zxf #{TMP} -C #{node['filestat_exporter']['storage']} --strip-components 1"

  # Change Owner and Permissions:
  file "#{node['filestat_exporter']['storage']}filestat_exporter" do
    owner 'root'
    group 'root'
    mode  '755'
  end

  # Create Link
  link "#{node['filestat_exporter']['location']}filestat_exporter" do
    to "#{node['filestat_exporter']['storage']}filestat_exporter"
  end
end
