git '/home/kazu634/repo/fzf' do
  repository 'https://github.com/junegunn/fzf.git'
  user 'kazu634'
end

link '/home/kazu634/.fzf' do
  to '/home/kazu634/repo/fzf'
end

execute '/home/kazu634/.fzf/install --bin' do
  user 'kazu634'
end
