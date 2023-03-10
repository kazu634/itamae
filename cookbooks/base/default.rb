[
  # only install amd64 package
  # http://d.hatena.ne.jp/ritchey/20121229
  'dpkg --remove-architecture i386',

  # Execute `apt update`
  'apt update',
].each do |cmd|
  execute cmd do
    user 'root'

    only_if 'dpkg --print-architecture | grep i386'
  end
end

# Create /etc/sudoers.d/
directory '/etc/sudoers.d/' do
  owner 'root'
  group 'root'
  mode '750'
end

# motd configurations:
remote_file '/etc/motd.tail' do
  owner 'root'
  group 'root'
  mode '644'
end

remote_file '/etc/update-motd.d/99-motd-update' do
  owner 'root'
  group 'root'
  mode '755'
end

# Install the necessary packages:
include_recipe './packages.rb'

# Lang Setting:
include_recipe './lang.rb'

# `unattended-upgrade` settings:
include_recipe './unattended-upgrade.rb'

# `ufw` configurations:
include_recipe './ufw.rb'

# `sshd` configurations:
include_recipe './ssh.rb'

# `fortune` configurations:
include_recipe './fortune.rb'

# timezone configurations:
include_recipe './timezone.rb'

# kernel configurations:
include_recipe './kernel.rb'

# Install mc command:
include_recipe './mc.rb'

# Install lsyncd command:
include_recipe './lsyncd.rb'

# Install starship command:
include_recipe './starship.rb'

# recipes for Ubuntu 16.04
if node['platform_version'].to_f == 16.04
  # ntp configurations
  include_recipe './ntp.rb'

  # misc recipe
  include_recipe './unnecessary.rb'
end

# recipes for Ubuntu 20.04
if node['platform_version'].to_f == 20.04
  remote_file '/etc/multipath.conf' do
    owner 'root'
    group 'root'
    mode  '0644'

    notifies :restart, 'service[multipath-tools]'
  end

  service 'multipath-tools' do
    action :nothing
  end
end

# AWS EC2 Swap Setting:
if node['is_ec2']
  include_recipe './aws_ec2.rb'
end
