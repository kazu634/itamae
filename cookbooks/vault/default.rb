include_recipe './attributes.rb'

include_recipe './install.rb'

if node['vault']['manager']
  include_recipe './setup.rb'
end
