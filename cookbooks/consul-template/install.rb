# -------------------------------------------
# Calculating the latest `consul-template` version:
# -------------------------------------------
download_url = ''
tag_version  = ''

begin
  require 'net/http'

  uri = URI.parse('https://releases.hashicorp.com/consul-template/')

  Timeout.timeout(3) do
    response = Net::HTTP.get_response(uri)

    if response.body =~ /consul-template_(\d+\.\d+\.\d+)/
      tag_version = $1
      download_url = \
        "#{node['consul-template']['base_binary_url']}#{tag_version}/consul-template_#{tag_version}_linux_#{node['consul-template']['arch']}.zip"
    end
  end
rescue
  # Abort the chef client process:
  raise 'Cannot connect to https://releases.hashicorp.com/consul-template/'
end

# -------------------------------------------
# Main Part
# -------------------------------------------

# バージョン確認して、アップデート必要かどうか確認
result = run_command("consul-template --version 2>&1 | grep #{tag_version}", error: false)
if result.exit_status != 0
  # Download:
  execute "wget #{download_url} -O #{node['consul-template']['tmp_path']}"

  # Unzip:
  execute "unzip -qo #{node['consul-template']['tmp_path']}" do
    cwd '/opt/consul/bin/'
  end

  file '/opt/consul/bin/consul-template' do
    owner 'root'
    group 'root'
    mode '755'
  end

  # Create link:
  link '/usr/local/bin/consul-template' do
    user 'root'
    to '/opt/consul/bin/consul-template'
  end
end
