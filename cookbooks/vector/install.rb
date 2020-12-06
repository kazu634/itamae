vector_url = ''
vector_deb = ''

tag        = ''
vtag       = ''

# Calculate the Download URL:
begin
  require 'net/http'

  uri = URI.parse('https://github.com/timberio/vector/releases/latest')

  Timeout.timeout(3) do
    response = Net::HTTP.get_response(uri)

    vtag     = $1 if response.body =~ %r{tag\/(v\d+\.\d+\.\d+)}
    tag      = vtag.sub(/^v/, '')

    vector_deb = "#{node['vector']['debPrefix']}#{tag}#{node['vector']['debPostfix']}"
    vector_url = "#{node['vector']['url']}/#{vtag}/#{vector_deb}"
  end
rescue
  # Abort the chef client process:
  raise 'Cannot connect to http://github.com.'
end

# バージョン確認して、アップデート必要かどうか確認
result = run_command("vector --version 2>&1 | grep #{tag}", error: false)
if result.exit_status != 0
  # Download:
  TMP = "/tmp/#{vector_deb}"

  execute "wget #{vector_url} -O #{TMP}"

  execute "dpkg -i #{TMP}"
end
