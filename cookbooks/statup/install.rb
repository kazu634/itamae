URL = 'https://assets.statup.io/install.sh'
TMP = '/tmp/install.sh'

# Download install script
execute "wget #{URL} -O #{TMP}" do
  user 'root'

  not_if 'test -e /usr/local/bin/statup'
end

file TMP do
  mode '755'

  not_if 'test -e /usr/local/bin/statup'
end

# Execute install script:
execute TMP do
  user 'root'

  not_if 'test -e /usr/local/bin/statup'
end
