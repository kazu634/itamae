# Retrieve the default values:
include_recipe './attributes.rb'

# Install statup
include_recipe './install.rb'

# Setup statup
include_recipe './setup.rb'

# Setup statup
include_recipe './ssl.rb'
