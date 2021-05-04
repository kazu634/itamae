#####################################
# LEGO Settings
#####################################
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


#####################################
# Deploy nginx Settings
#####################################

# Deploy the `sudoers` file:
remote_file '/etc/sudoers.d/webadm' do
  owner 'root'
  group 'root'
  mode '440'
end

# Create directories:
%w(/home/webadm/.ssh /home/webadm/repo).each do |d|
  directory d do
    owner 'webadm'
    group 'webadm'
    mode '700'
  end
end

# Deploy `~/.ssh/.ssh/authorized_keys`:
encrypted_remote_file '/home/webadm/.ssh/authorized_keys' do
  owner 'webadm'
  group 'webadm'
  mode '600'
  source   'files/home/webadm/.ssh/authorized_keys'
  password ENV['ITAMAE_PASSWORD']
end

# Deploy secret keys
%w( id_rsa.github id_rsa.chef ).each do |conf|
  encrypted_remote_file "/home/webadm/.ssh/#{conf}" do
    owner 'webadm'
    group 'webadm'
    mode '600'
    source   "files/home/webadm/.ssh/#{conf}"
    password ENV['ITAMAE_PASSWORD']
  end
end

# Create `repo` directory:
git '/home/webadm/repo/nginx-config' do
  user 'webadm'
  repository 'https://gitea.kazu634.com/kazu634/nginx-config.git'
end

execute '/home/webadm/repo/nginx-config/deploy.sh' do
  user 'root'
  cwd '/home/webadm/repo/nginx-config/'
end

service 'consul-template' do
  action :restart
end

service 'nginx' do
  action :restart
end
