# Manager setting:
if node['td-agent']['forward']
  gem_package 'fluent-plugin-s3' do
    action :upgrade
    gem_binary '/usr/sbin/td-agent-gem'
  end

  encrypted_remote_file '/etc/td-agent/conf.d/processor_nginx.conf' do
    owner 'root'
    group 'root'
    mode '644'
    source   'files/etc/td-agent/conf.d/processor_nginx.conf'
    password ENV['ITAMAE_PASSWORD']
  end
end

# Agent setting:
remote_file '/etc/td-agent/conf.d/forwarder_nginx.conf' do
  owner 'root'
  group 'root'
  mode '644'
end
