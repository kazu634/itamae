# `consul-template`-related paths:
%w( /etc/consul-template.d ).each do |d|
  directory d do
    owner 'root'
    group 'root'

    mode '755'
  end
end
