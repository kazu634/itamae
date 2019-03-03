include_recipe './attributes.rb'

if node['blog']['production']
  include_recipe './ssl.rb'
  include_recipe './nginx.rb'
end
