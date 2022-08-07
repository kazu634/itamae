HOME = '/home/kazu634'

# Create User:
user 'kazu634' do
  password '$1$7Zch2rSt$XEFT8T9XS24gY1rctRLtA1'

  create_home true
  home HOME

  shell '/usr/bin/zsh'
end

# Create directories:
%w( repo src tmp works .cache ).each do |d|
  directory "#{HOME}/#{d}" do
    owner 'kazu634'
    group 'kazu634'
    mode '755'
  end
end

# `git-now` deployment:
git '/home/kazu634/repo/git-now' do
  repository 'https://github.com/iwata/git-now.git'
  user 'kazu634'

  recursive true
end

execute 'make install' do
  user 'root'
  cwd '/home/kazu634/repo/git-now/'

  not_if 'which git-now'
end

# Deploy dot files:
git '/home/kazu634/repo/dotfiles' do
  repository 'https://gitea.kazu634.com/kazu634/dotfiles.git'
  user 'kazu634'
end

execute 'install_dotfiles' do
  user 'root'
  command 'su - kazu634 -c "/home/kazu634/repo/dotfiles/install.sh"'

  not_if 'test -f /home/kazu634/.zshenv'
end

# Deploy `zplug`:
git '/home/kazu634/.zplug' do
  repository 'https://github.com/zplug/zplug.git'
  user 'kazu634'
end

# sudoers
remote_file '/etc/sudoers.d/kazu634' do
  owner 'root'
  group 'root'
  mode '440'
end

# automatically delete the /home/kazu634/tmp directory:
remote_file '/etc/cron.d/remove_tmp' do
  owner 'root'
  group 'root'
  mode '644'
end
