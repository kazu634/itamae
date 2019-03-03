# Make swap file:
[
  'dd if=/dev/zero of=/swap.img bs=1M count=2048 && chomod 600 /swap.img',
  'mkswap /swap.img'
].each do |cmd|
  execute cmd do
    user 'root'

    only_if 'test ! -f /swap.img -a `cat /proc/swaps | wc -l` -eq 1'
  end
end

# Add the fstab entry:
file '/etc/fstab' do
  action :edit

  block do |content|
    content << "/swap.img /dev/null swap defaults 0 2\n"
  end

  not_if 'grep swap.img /etc/fstab'
end

# Mount the swap file:
execute 'swapon -ae' do
  only_if 'test `cat /proc/swaps | wc -l` -eq 1'
end
