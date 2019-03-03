# Execute `apt update`:
execute 'apt update'

# Install the necessary packages:
%w[build-essential zsh vim-nox debian-keyring screen curl dstat].each do |pkg|
  package pkg
end

# Install the extra kernel:
unless node['is_ec2']
  case run_command('grep VERSION_ID /etc/os-release | awk -F\" \'{print $2}\'').stdout.chomp
  when "18.04"
    package 'linux-image-extra-virtual'
  else
    KERNEL = run_command("uname -r").stdout.chomp
    package "linux-image-extra-#{KERNEL}"
  end
end

### Here we are going to install git.
# Constants:
KEYSRV = 'hkp://keyserver.ubuntu.com:80'
ID = 'E1DF1F24'

GIT_PREPUSH = '/usr/share/git-core/templates/hooks/pre-push'
PREPUSH = 'https://gist.github.com/kazu634/8267388/raw/e9202cd4c29a66723c88d2be05f3cd19413d2137/pre-push'

# Retrieve the Ubuntu code:
DIST = run_command('lsb_release -cs').stdout.chomp

# Add the public key file to install `git`
execute "apt-key adv --keyserver #{KEYSRV} --recv-keys #{ID}" do
  not_if 'apt-key list | grep E1DF1F24'
end

# Deploy the `apt` sources:
template '/etc/apt/sources.list.d/git.list' do
  action :create
  variables(distribution: DIST)
end

execute 'apt update' do
  not_if 'LANG=C apt-cache policy git | grep Installed | grep ppa'
end

execute 'apt install git -y' do
  not_if 'LANG=C apt-cache policy git | grep Installed | grep ppa'
end

execute "wget #{PREPUSH} -O #{GIT_PREPUSH}" do
  not_if "test -e #{GIT_PREPUSH}"
end

[
  '/usr/share/git-core/templates/hooks/pre-commit',
  '/usr/share/git-core/templates/hooks/prepare-commit-msg',
].each do |conf|
  remote_file conf do
    user 'root'
    owner 'root'
    group 'root'
    mode '644'
  end
end
