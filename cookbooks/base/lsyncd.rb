package 'lsyncd'

# Create /etc/sudoers.d/
%w( /etc/lsyncd /var/log/lsyncd ).each do |d|
  directory d do
    owner 'root'
    group 'root'
    mode  '755'
  end
end

directory '/root/.ssh/' do
  owner 'root'
  group 'root'
  mode  '0700'
end

%w(id_rsa known_hosts).each do |f|
  encrypted_remote_file "/root/.ssh/#{f}" do
    owner 'root'
    group 'root'
    mode  '600'

    source "files/root/.ssh/#{f}"

    password ENV['ITAMAE_PASSWORD']

    # Do not overwrite:
    not_if "test -e /root/.ssh/#{f}"
  end
end

remote_file '/etc/logrotate.d/lsyncd' do
  owner 'root'
  group 'root'
  mode  '644'
end
