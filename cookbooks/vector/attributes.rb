# -------------------------------------------
# Specifying the default settings:
# -------------------------------------------
case run_command('grep VERSION_ID /etc/os-release | awk -F\" \'{print $2}\'').stdout.chomp
when "20.04"
  cmd = 'LANG=C ip a | grep "inet " | grep -v -E "(127|172)" | cut -d" " -f6 | perl -pe "s/\/.+//g"'

when "18.04"
  cmd = 'LANG=C /sbin/ifconfig | grep "inet " | grep -v -E "(127|172)" | cut -d" " -f10'

else
  cmd = 'LANG=C /sbin/ifconfig | grep "inet addr" | grep -v -E "(127|172)" | awk "{print $2;}" | cut -d: -f2 | cut -f 1 -d " " | tail -1'
end

ipaddr = run_command(cmd).stdout.chomp

node.reverse_merge!({
  'vector' => {
    'url' => 'https://github.com/vectordotdev/vector/releases/download/',
    'ipaddr' => ipaddr,
    'debPrefix' => 'vector-',
    'debPostfix' => '-amd64.deb',
    'isSyslog' => false
  },
})
