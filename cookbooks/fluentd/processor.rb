%w( processor.conf processor_consul.conf ).each do |f|
  remote_file "/etc/td-agent/conf.d/#{f}" do
    owner 'root'
    group 'root'
    mode '644'
  end
end
