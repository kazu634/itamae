prometheus_url = ''
prometheus_bin = ''

vtag           = ''
tag            = ''

# Calculate the Download URL:
begin
  require 'net/http'

  uri = URI.parse('https://github.com/prometheus/prometheus/releases/latest')

  Timeout.timeout(3) do
    response = Net::HTTP.get_response(uri)

    vtag = $1 if response['location'] =~ %r{tag\/(v\d+\.\d+\.\d+)}
    tag = vtag.sub(/^v/, '')

    prometheus_bin = "#{node['prometheus']['prefix']}#{tag}#{node['prometheus']['postfix']}"

    prometheus_url = "#{node['prometheus']['url']}/#{vtag}/#{prometheus_bin}"
  end
rescue
  # Abort the chef client process:
  raise 'Cannot connect to http://github.com.'
end


# バージョン確認して、アップデート必要かどうか確認
result = run_command("prometheus --version 2>&1 | grep #{tag}", error: false)
if result.exit_status != 0
  # Download:
  TMP = "/tmp/#{prometheus_bin}"

  execute "wget #{prometheus_url} -O #{TMP}"

  # Install:
  directory node['prometheus']['storage'] do
    owner 'root'
    group 'root'
    mode '755'
  end

  execute "tar zxf #{TMP} -C #{node['prometheus']['storage']} --strip-components 1"

  # Change Owner and Permissions:
  file "#{node['prometheus']['storage']}prometheus" do
    owner 'root'
    group 'root'
    mode  '755'
  end

  # Create Link
  link "#{node['prometheus']['location']}prometheus" do
    to "#{node['prometheus']['storage']}prometheus"
  end
end
