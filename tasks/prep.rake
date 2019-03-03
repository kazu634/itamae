#!/usr/bin/env rake

desc 'Invoke itamae command for the first time'
task :prep do
  node = `ls -1 nodes/*.json | xargs -I % basename % .json | peco`
  node.chomp!

  sh "ITAMAE_PASSWORD=musashi bundle ex itamae ssh --host #{node} -j nodes/#{node}.json entrypoint.rb"
end
