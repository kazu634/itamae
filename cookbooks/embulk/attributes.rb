# -------------------------------------------
# Specifying the default settings:
# -------------------------------------------
cmd = 'LANG=C /sbin/ifconfig | grep "inet addr" | grep -v 127.0.0.1 | awk "{print $2;}" | cut -d: -f2 | cut -f 1 -d " " | tail -1'
ipaddr = run_command(cmd).stdout.chomp

node.reverse_merge!({
  'embulk' => {
    'base_binary_url' => 'https://dl.bintray.com/embulk/maven/embulk-',
    'version' => '0.8.33',
    'extension' => '.jar',
    'install_path' => '/opt/embulk'
  }
})
