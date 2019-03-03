# -------------------------------------------
# Specifying the default settings:
# -------------------------------------------
cmd = 'LANG=C /sbin/ifconfig | grep "inet addr" | grep -v 127.0.0.1 | awk "{print $2;}" | cut -d: -f2 | cut -f 1 -d " " | tail -1'
ipaddr = run_command(cmd).stdout.chomp

node.reverse_merge!({
  'nvm' => {
    'url_prefix' => 'https://raw.githubusercontent.com/creationix/nvm',
    'url_postfix' => 'install.sh',
    'node_version' => 'v8.11.2'
  },
  'wekan' => {
    'url' => 'https://releases.wekan.team',
    'ipaddr' => ipaddr
  }
})
