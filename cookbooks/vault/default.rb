include_recipe './attributes.rb'

include_recipe './install.rb'

%w( agent tokens ).each do |d|
  directory "/etc/vault.d/#{d}" do
    owner 'vault'
    group 'vault'
    mode '0755'
  end
end

if node['vault']['manager']
  include_recipe './setup.rb'
end
