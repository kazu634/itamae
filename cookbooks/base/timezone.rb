case run_command('grep VERSION_ID /etc/os-release | awk -F\" \'{print $2}\'').stdout.chomp
when "18.04"
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
