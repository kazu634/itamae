directory '/root/.ssh' do
  owner 'root'
  group 'root'
  mode '700'
end

# Deploy `~/.ssh/.ssh/authorized_keys`:
encrypted_remote_file '/root/.ssh/authorized_keys' do
  owner 'root'
  group 'root'
  mode '600'
  source   'files/root/.ssh/authorized_keys'
  password ENV['ITAMAE_PASSWORD']
end

# Deploy secret keys
%w( id_rsa.github id_rsa.chef amazon.pem ).each do |conf|
  encrypted_remote_file "/root/.ssh/#{conf}" do
    owner 'root'
    group 'root'
    mode '600'
    source   "files/root/.ssh/#{conf}"
    password ENV['ITAMAE_PASSWORD']
  end
end

# Deploy .ssh/config:
remote_file '/root/.ssh/config' do
  owner 'root'
  group 'root'
  mode '644'
end


%w(filter-column filter-row output-mysql output-postgresql input-mysql filter-gsub).each do |p|
  execute "embulk gem install embulk-#{p}" do
    user 'root'

    not_if "embulk gem list | grep #{p}"
  end
end
