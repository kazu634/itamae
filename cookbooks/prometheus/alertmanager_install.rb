alertmanager_url = ''
alertmanager_bin = ''

vtag             = ''
tag              = ''

# Calculate the Download URL:
begin
  require 'net/http'

  uri = URI.parse('https://github.com/prometheus/alertmanager/releases/latest')

  Timeout.timeout(3) do
    response = Net::HTTP.get_response(uri)

    vtag = $1 if response['location'] =~ %r{tag\/(v\d+\.\d+\.\d+)}
    tag = vtag.sub(/^v/, '')

    alertmanager_bin = "#{node['alertmanager']['prefix']}#{tag}#{node['alertmanager']['postfix']}"

    alertmanager_url = "#{node['alertmanager']['url']}/#{vtag}/#{alertmanager_bin}"
  end
rescue
  # Abort the chef client process:
  raise 'Cannot connect to http://github.com.'
end


# バージョン確認して、アップデート必要かどうか確認
result = run_command("alertmanager --version 2>&1 | grep #{tag}", error: false)
if result.exit_status != 0
  # Download:
  TMP = "/tmp/#{alertmanager_bin}"

  execute "wget #{alertmanager_url} -O #{TMP}"

  # Install:
  directory node['alertmanager']['storage'] do
    owner 'root'
    group 'root'
    mode '755'
  end

  execute "tar zxf #{TMP} -C #{node['alertmanager']['storage']} --strip-components 1"

  # Change Owner and Permissions:
  file "#{node['alertmanager']['storage']}alertmanager" do
    owner 'root'
    group 'root'
    mode  '755'
  end

  # Create Link
  link "#{node['alertmanager']['location']}alertmanager" do
    to "#{node['alertmanager']['storage']}alertmanager"
  end
end
