rclone_url = ''
rclone_dir = ''

vtag     = ''

# Calculate the Download URL:
begin
  require 'net/http'

  uri = URI.parse('https://github.com/rclone/rclone/releases/latest')

  Timeout.timeout(3) do
    response = Net::HTTP.get_response(uri)

    vtag     = $1 if response.body =~ %r{tag\/(v\d+\.\d+\.\d+)}

    rclone_dir = "#{node['rclone']['prefix']}#{vtag}#{node['rclone']['postfix']}"
    rclone_url = "#{node['rclone']['url']}/#{vtag}/#{rclone_dir}.zip"
  end
rescue
  # Abort the chef client process:
  raise 'Cannot connect to http://github.com.'
end

# バージョン確認して、アップデート必要かどうか確認
result = run_command("rclone --version 2>&1 | grep #{vtag}", error: false)
if result.exit_status != 0
  # Download:
  TMP = "/tmp/#{rclone_dir}.zip"

  execute "wget #{rclone_url} -O #{TMP}"

  # Install:
  execute "unzip -d /opt/ -o #{TMP}"
  execute "mv /opt/#{rclone_dir} /opt/rclone"

  # Change Owner and Permissions:
  file "#{node['rclone']['storage']}rclone" do
    owner 'root'
    group 'root'
    mode  '755'
  end

  # Create Link
  link "#{node['rclone']['location']}rclone" do
    to "#{node['rclone']['storage']}rclone"
  end
end
