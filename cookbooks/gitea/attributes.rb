# -------------------------------------------
# Specifying the default settings:
# -------------------------------------------
node.reverse_merge!({
  'gitea' => {
    'url' => 'https://github.com/go-gitea/gitea/releases/download/',
    'prefix' => 'gitea-',
    'postfix' => '-linux-amd64',
    'storage' => '/opt/gitea/',
    'location' => '/usr/local/bin/'
  },
  'go-mmproxy' => {
    'url' => 'https://github.com/path-network/go-mmproxy/releases/',
    'bin_url' => 'https://github.com/path-network/go-mmproxy/releases/download/2.0/go-mmproxy-2.0-centos8-x86_64',
    'storage' => '/opt/go-mmproxy/',
    'location' => '/usr/local/bin/'
  },
})
