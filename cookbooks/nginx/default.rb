# Retrieve the default values:
include_recipe './attributes.rb'

# Kernel Parameters:
include_recipe './kernel.rb'

# Prerequisites for Building nginx:
include_recipe './webadm.rb'

# Install Let's Encrypt:
include_recipe './lego.rb'

# Build nginx:
include_recipe './build.rb'

# Setup nginx:
include_recipe './setup.rb'
