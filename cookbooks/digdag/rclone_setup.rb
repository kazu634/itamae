# Deploy the files:
directory '/home/kazu634/.config/rclone/' do
  owner 'kazu634'
  group 'kazu634'
  mode '750'
end

remote_file "/home/kazu634/.config/rclone/rclone.conf" do
  owner 'kazu634'
  group 'kazu634'
  mode '600'
end

directory '/root/.config/rclone/' do
  owner 'root'
  group 'root'
  mode '750'
end

remote_file "/root/.config/rclone/rclone.conf" do
  owner 'kazu634'
  group 'kazu634'
  mode '600'
end
