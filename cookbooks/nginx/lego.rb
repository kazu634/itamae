# ---
# Variables & Constants
USER         = 'webadm'
GROUP        = 'webadm'
TARBALL      = '/home/webadm/lego/lego.tar.gz'
WORKDIR      = '/home/webadm/lego'
LEGO_DIR     = '/opt/local/lego'
LEGO         = '/opt/local/lego/lego'
LEGO_STORAGE = '/etc/lego/'

vtag         = ''
tag_version  = ''
lego         = ''
# ---

# -------------------------------------------
# Calculating the latest `nginx-build` version:
# -------------------------------------------
begin
  require 'net/http'

  uri = URI.parse('https://github.com/go-acme/lego/releases/latest')

  Timeout.timeout(3) do
    response = Net::HTTP.get_response(uri)

    if response.body =~ %r{tag\/(v\d+\.\d+\.\d+)}
      vtag        = $1
      tag_version = vtag.sub('v', '')

      lego = "https://github.com/go-acme/lego/releases/download/#{vtag}/lego_#{vtag}_linux_amd64.tar.gz"
    end
  end
rescue
  # Abort the chef client process:
  raise 'Cannot connect to http://github.com.'
end

directory WORKDIR do
  owner USER
  group GROUP
  mode '755'
end

directory LEGO_DIR do
  owner 'root'
  group 'root'
  mode '755'
end

# バージョン確認して、アップデート必要かどうか確認
result = run_command("lego -v | grep #{tag_version}", error: false)
if result.exit_status != 0
  execute "wget #{lego} -O #{TARBALL}" do
    user USER
  end

  execute "tar xf #{TARBALL} -C #{LEGO_DIR}" do
    user 'root'
  end

  file LEGO do
    user 'root'
    group 'root'
    mode '755'
  end

  link '/usr/local/bin/lego' do
    user 'root'
    to LEGO
    force true
  end
end

directory "#{LEGO_STORAGE}" do
  user 'root'
  group 'root'
  mode '755'
end

encrypted_remote_file "#{LEGO_STORAGE}/lego_run.sh" do
  owner 'root'
  group 'root'
  mode '500'
  source   "files/#{LEGO_STORAGE}/lego_run.sh"
  password ENV['ITAMAE_PASSWORD']
end

execute "#{LEGO_STORAGE}/lego_run.sh" do
  user 'root'
  cwd LEGO_STORAGE
  not_if "test -d #{LEGO_STORAGE}/.lego"
end

encrypted_remote_file '/etc/cron.d/lego' do
  owner 'root'
  group 'root'
  mode '644'
  source   'files/etc/cron.d/lego'
  password ENV['ITAMAE_PASSWORD']
end

remote_file "/etc/lego/dhparams_4096.pem" do
  owner 'root'
  group 'root'
  mode '444'
end

execute "openssl rand 48 > /etc/lego/ticket.key"
