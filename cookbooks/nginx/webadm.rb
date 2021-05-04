# Create a user for managing `nginx`:
user 'webadm' do
  home '/home/webadm'
  shell '/bin/bash'
  password '$1$lzfGward$TODNAMe9S9v.BXqpCV0p60'
  create_home true
end

