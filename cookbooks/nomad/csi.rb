SYNOLOGY = node['nomad']['synology']

# 前提パッケージのインストール・セットアップ
%w( open-iscsi lsscsi sg3-utils multipath-tools scsitools ).each do |p|
  package p
end

execute "iscsiadm -m discoverydb -t st -p #{SYNOLOGY} --discover" do
  user 'root'
end

remote_file "/etc/multipath.conf" do
  user 'root'
  group 'root'
  mode '0644'

  notifies :restart, 'service[multipath-tools]'
end

%w( multipath-tools open-iscsi).each do |s|
  service s do
    action [:enable, :restart]
  end
end

# CNIプラグインのデプロイ・セットアップ
directory '/opt/cni/bin' do
  owner 'root'
  group 'root'

  mode '0755'
end

%w( bandwidth bridge dhcp firewall host-device host-local ipvlan loopback macvlan portmap ptp sbr static tuning vlan vrf ).each do |f|
  remote_file "/opt/cni/bin/#{f}" do
    owner 'root'
    group 'root'

    mode '0775'
  end
end

directory '/etc/cni' do
  owner 'root'
  group 'root'
  mode '0755'
end

remote_file '/etc/cni/nomad.conflist' do
  owner 'root'
  group 'root'
  mode '0644'
end

remote_file '/etc/nomad.d/csi.hcl' do
  owner 'nomad'
  group 'nomad'
  mode '0664'

  notifies :restart, 'service[nomad]'
end
