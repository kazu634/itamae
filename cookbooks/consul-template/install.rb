consulTemplate_zip = "#{node['consulTemplate']['zipPrefix']}#{node['consulTemplate']['version']}#{node['consulTemplate']['zipPostfix']}"
consulTemplate_url = "#{node['consulTemplate']['baseUrl']}#{node['consulTemplate']['version']}/#{consulTemplate_zip}"

# バージョン確認して、アップデート必要かどうか確認
result = run_command('which consul-template', error: false)
if result.exit_status != 0

  # Download:
  TMP = "/tmp/#{consulTemplate_zip}"

  execute "wget #{consulTemplate_url} -O #{TMP}"

  directory '/opt/consul-template' do
    owner 'root'
    group 'root'
    mode  '0755'
  end

  execute "unzip #{TMP} -d /opt/consul-template/" do
    not_if 'test -e /opt/consul-template/consul-template'
  end

  # Change Owner and Permissions:
  file "#{node['consulTemplate']['storage']}" do
    owner 'root'
    group 'root'
    mode  '755'
  end

  # Create Link
  link "#{node['consulTemplate']['location']}" do
    to "#{node['consulTemplate']['storage']}"
  end
end
