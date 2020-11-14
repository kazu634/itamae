# -------------------------------------------
# Specifying the default settings:
# -------------------------------------------
cmd = 'LANG=C /sbin/ifconfig | grep "inet addr" | grep -v 127.0.0.1 | awk "{print $2;}" | cut -d: -f2 | cut -f 1 -d " " | tail -1'
ipaddr = run_command(cmd).stdout.chomp

node.reverse_merge!({
  'digdag' => {
    'binary_url' => 'https://dl.digdag.io/digdag-latest',
    'install_path' => '/opt/digdag'
  },
  'rclone' => {
    'url' => 'https://github.com/rclone/rclone/releases/download/',
    'prefix' => 'rclone-',
    'postfix' => '-linux-amd64',
    'storage' => '/opt/rclone/',
    'location' => '/usr/local/bin/'
  },
})
