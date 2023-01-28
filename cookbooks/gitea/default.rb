# Loading the attributes:
include_recipe './attributes.rb'

# Install:
include_recipe './install-go-mmproxy.rb'

# Setup:
include_recipe './setup-go-mmproxy.rb'
