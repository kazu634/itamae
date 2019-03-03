# -------------------------------------------
# Specifying the default settings:
# -------------------------------------------
case run_command('grep VERSION_ID /etc/os-release | awk -F\" \'{print $2}\'').stdout.chomp
when "18.04"
  cmd = 'LANG=C /sbin/ifconfig | grep "inet " | grep -v 127.0.0.1 | cut -d" " -f10'
else
  cmd = 'LANG=C /sbin/ifconfig | grep "inet addr" | grep -v 127.0.0.1 | awk "{print $2;}" | cut -d: -f2 | cut -f 1 -d " " | tail -1'
end
ipaddr = run_command(cmd).stdout.chomp

node.reverse_merge!({
  'consul' => {
    'base_binary_url' => 'https://releases.hashicorp.com/consul/',
    'arch' => node['kernel']['machine'] =~ /x86_64/ ? 'amd64' : '386',
    'tmp_path' => '/tmp/itamae_tmp/consul.zip',
    'manager' => true,
    'manager_hosts' => '["192.168.10.110", "192.168.10.101", "192.168.10.111", "192.168.10.115"]',
    'ipaddr' => ipaddr
  }
})
