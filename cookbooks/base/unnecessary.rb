%w( apparmor iscsid lxc lxcfs lxd-containers lxd open-iscsi ).each do |s|
  service s do
    action :disable
  end
end
