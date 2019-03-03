# Deploy .vim configuration
git '/home/kazu634/.vim' do
  repository 'git://github.com/kazu634/vim.git'
  user 'kazu634'
end

# Deploy neobundle:
directory '/home/kazu634/.vim/bundle/' do
  owner 'kazu634'
  group 'kazu634'
  mode '755'
end

git '/home/kazu634/.vim/bundle/neobundle.vim' do
  repository 'git://github.com/Shougo/neobundle.vim'
  user 'kazu634'
end
