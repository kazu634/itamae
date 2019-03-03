gem_package 'fluent-plugin-slack' do
  action :upgrade
  gem_binary '/usr/sbin/td-agent-gem'
end

encrypted_remote_file '/etc/td-agent/conf.d/watcher.conf' do
  owner 'root'
  group 'root'
  mode '644'
  source   'files/etc/td-agent/conf.d/watcher.conf'
  password ENV['ITAMAE_PASSWORD']
end
