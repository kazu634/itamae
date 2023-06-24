case node['platform_version']
when "18.04", "20.04", "22.04"
  execute 'timedatectl set-timezone Asia/Tokyo' do
    not_if 'timedatectl | grep Tokyo'
  end
else
  remote_file '/etc/timezone' do
    user 'root'
    owner 'root'
    group 'root'
    mode '644'
  end

  [
    'cp -f /usr/share/zoneinfo/Asia/Tokyo /etc/localtime'
  ].each do |cmd|
    execute cmd do
      user 'root'

      not_if 'diff /usr/share/zoneinfo/Asia/Tokyo /etc/localtime'
    end
  end
end
