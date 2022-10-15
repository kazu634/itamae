gitea_url = ''
gitea_bin = ''

vtag     = ''
tag      = ''

# Calculate the Download URL:
begin
  require 'net/http'

  uri = URI.parse('https://github.com/go-gitea/gitea/releases/latest')

  Timeout.timeout(3) do
    response = Net::HTTP.get_response(uri)

    vtag     = $1 if response['location'] =~ %r{tag\/(v\d+\.\d+\.\d+)}
    tag      = vtag.sub(/^v/, '')

    gitea_bin = "#{node['gitea']['prefix']}#{tag}#{node['gitea']['postfix']}"
    gitea_url = "#{node['gitea']['url']}/#{vtag}/#{gitea_bin}"
  end
rescue
  # Abort the chef client process:
  raise 'Cannot connect to http://github.com.'
end

# バージョン確認して、アップデート必要かどうか確認
result = run_command("gitea --version 2>&1 | grep #{tag}", error: false)
if result.exit_status != 0
  # Download:
  TMP = "/tmp/#{gitea_bin}"

  execute "wget #{gitea_url} -O #{TMP}"

  # Install:
  directory node['gitea']['storage'] do
    owner 'root'
    group 'root'
    mode '755'
  end

  execute "mv #{TMP} #{node['gitea']['storage']}/gitea"

  # Change Owner and Permissions:
  file "#{node['gitea']['storage']}/gitea" do
    owner 'root'
    group 'root'
    mode  '755'
  end

  # Create Link
  link "#{node['gitea']['location']}/gitea" do
    to "#{node['gitea']['storage']}/gitea"
  end
end
