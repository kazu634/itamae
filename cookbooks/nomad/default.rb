include_recipe './attributes.rb'

include_recipe './install.rb'

if node['nomad']['manager'] || node['nomad']['client']
  include_recipe './setup.rb'
  include_recipe './csi.rb'

  include_recipe './shared_dir.rb'
end
