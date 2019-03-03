# Ensure that `unzip` and `dnsmasq` are available:
%w( unzip ).each do |p|
  package p do
    action :install
  end
end

%w( /opt/consul/bin ).each do |d|
  directory d do
    owner 'root'
    group 'root'
    mode '755'
  end
end
