# -------------------------------------------
# Specifying the default settings:
# -------------------------------------------
node.reverse_merge!({
  'peco' => {
    'url' => 'https://github.com/peco/peco/releases/download/',
    'tarball' => 'peco_linux_amd64.tar.gz',
    'prefix' => '/usr/local'
  }
})
