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
})
