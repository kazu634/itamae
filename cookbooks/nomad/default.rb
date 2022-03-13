include_recipe './attributes.rb'

include_recipe './install.rb'

if node['nomad']['manager'] || node['nomad']['client']
  include_recipe './setup.rb'
  include_recipe './csi.rb'
end
