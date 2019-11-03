#!/usr/bin/env rake

desc 'Invoke itamae command'
task :itamae do
  node = `ls -1 nodes/*.json | xargs -I % basename % .json | fzf`
  node.chomp!

  sh "ITAMAE_PASSWORD=musashi bundle ex itamae ssh --host #{node} -j nodes/#{node}.json -p 10022 entrypoint.rb"
end
