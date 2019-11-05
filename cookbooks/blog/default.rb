include_recipe './attributes.rb'

if node['blog']['production']
  include_recipe './nginx.rb'
end
