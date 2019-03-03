MC = 'https://dl.minio.io/client/mc/release/linux-amd64/mc'
LOCATION = '/usr/local/bin/mc'

execute "wget #{MC} -O #{LOCATION}" do
  not_if "test -e #{LOCATION}"
end

file LOCATION do
  mode '755'
  user 'root'
  group 'root'
end
