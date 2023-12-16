URL='https://github.com/cloudflare/cloudflared/releases/latest/download/cloudflared-linux-amd64'
BINARY='/usr/local/bin/cloudflared'

[
  "wget #{URL} -O #{BINARY}",
].each do |cmd|
  execute cmd do
    user 'root'
    cwd '/tmp/itamae_tmp/'

    not_if "test -e #{BINARY}"
  end
end

file "#{BINARY}" do
  owner 'root'
  group 'root'
  mode '755'
end
