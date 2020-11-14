include_recipe './attributes.rb'

include_recipe './install.rb'

include_recipe './setup.rb'

include_recipe './rclone_install.rb'

# AWS EC2 Swap Setting:
if !node['is_ec2']
  include_recipe './shared_dir.rb'
end
