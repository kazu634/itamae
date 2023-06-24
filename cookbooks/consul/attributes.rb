# -------------------------------------------
# Specifying the default settings:
# -------------------------------------------
case run_command('grep VERSION_ID /etc/os-release | awk -F\" \'{print $2}\'').stdout.chomp
when "20.04", "22.04"
  cmd = 'LANG=C ip a | grep "inet " | grep -v -E "(127|172)" | cut -d" " -f6 | perl -pe "s/\/.+//g"'

when "18.04"
  cmd = 'LANG=C /sbin/ifconfig | grep "inet " | grep -v -E "(127|172)" | cut -d" " -f10'

else
  cmd = 'LANG=C /sbin/ifconfig | grep "inet addr" | grep -v -E "(127|172)" | awk "{print $2;}" | cut -d: -f2 | cut -f 1 -d " " | tail -1'
end
ipaddr = run_command(cmd).stdout.chomp

cmd = 'grep nameserver /run/systemd/resolve/resolv.conf | grep -v 8.8.8.8 | grep -v 127.0.0.1 | perl -pe "s/nameserver //g" | sort | uniq | perl -pe "s/\n/ /g"'
dns = run_command(cmd).stdout.chomp

node.reverse_merge!({
  'consul' => {
    'manager' => false,
    'manager_hosts' => '"192.168.10.101", "192.168.10.251", "192.168.10.252", "192.168.10.253"',
    'ipaddr' => ipaddr,
    'dns' => dns,
    'encrypt' => 's2T3XUTb9MjHYOw8I820O5YkN2G6eJrjLjJRTnEAKoM=',
    'token' => '63de6edb-0cb0-de95-d5f1-7facf616c26d'
  }
})
