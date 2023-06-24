include_recipe './attributes.rb'

if node['everun']['production']
  include_recipe './nginx.rb'
end
