%w(apt-transport-https ca-certificates curl software-properties-common).each do |p|
  package p do
    action :install
  end
end

execute 'curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -' do
  not_if 'apt-key fingerprint 0EBFCD88 | grep 9DC8'
end

execute 'add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable" -y' do
  not_if 'which docker'
end

execute 'apt-get update' do
  not_if 'which docker'
end

%w(docker-ce docker-ce-cli containerd.io docker-compose-plugin).each do |p|
  package p
end

service 'docker' do
  action :nothing
end
