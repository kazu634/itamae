loki_url = ''
loki_bin = ''

vtag     = ''
tag      = ''

# Calculate the Download URL:
begin
  require 'net/http'

  uri = URI.parse('https://github.com/grafana/loki/releases/latest')

  Timeout.timeout(3) do
    response = Net::HTTP.get_response(uri)

    vtag     = $1 if response['location'] =~ %r{tag\/(v\d+\.\d+\.\d+)}
    tag      = vtag.sub(/^v/, '')

    loki_bin = "#{node['loki']['zip']}"
    loki_url = "#{node['loki']['url']}/#{vtag}/#{loki_bin}"
  end
rescue
  # Abort the chef client process:
  raise 'Cannot connect to http://github.com.'
end


# バージョン確認して、アップデート必要かどうか確認
result = run_command("loki --version 2>&1 | grep #{tag}", error: false)
if result.exit_status != 0
  # Download:
  TMP = "/tmp/#{loki_bin}"

  execute "wget #{loki_url} -O #{TMP}"

  # Install:
  directory node['loki']['storage'] do
    owner 'root'
    group 'root'
    mode '755'
  end

  execute "unzip -d #{node['loki']['storage']} -o #{TMP}"

  # Change Owner and Permissions:
  file "#{node['loki']['storage']}loki-linux-amd64" do
    owner 'root'
    group 'root'
    mode  '755'
  end

  # Create Link
  link "#{node['loki']['location']}loki" do
    to "#{node['loki']['storage']}loki-linux-amd64"
  end
end
