promtail_url = ''
promtail_bin = ''

tag               = ''
vtag              = ''

# Calculate the Download URL:
begin
  require 'net/http'

  uri = URI.parse('https://github.com/grafana/loki/releases/latest')

  Timeout.timeout(3) do
    response = Net::HTTP.get_response(uri)

    vtag = $1 if response.body =~ %r{tag\/(v\d+\.\d+\.\d+)}
    tag = vtag.sub(/^v/, '')

    promtail_url = "#{node['promtail']['url']}/#{vtag}/#{node['promtail']['bin']}"
  end
rescue
  # Abort the chef client process:
  raise 'Cannot connect to http://github.com.'
end

# バージョン確認して、アップデート必要かどうか確認
result = run_command("promtail --version 2>&1 | grep #{tag}", error: false)
if result.exit_status != 0
  # Download:
  TMP = "/tmp/#{node['promtail']['bin']}"

  execute "wget #{promtail_url} -O #{TMP}"

  # Install:
  directory node['promtail']['storage'] do
    owner 'root'
    group 'root'
    mode '755'
  end

  execute "unzip #{TMP} -d #{node['promtail']['storage']}"
  execute "mv #{node['promtail']['storage']}promtail-linux-amd64 #{node['promtail']['storage']}promtail"

  # Change Owner and Permissions:
  file "#{node['promtail']['storage']}promtail" do
    owner 'root'
    group 'root'
    mode  '755'
  end

  # Create Link
  link "#{node['promtail']['location']}promtail" do
    to "#{node['promtail']['storage']}promtail"
  end
end
