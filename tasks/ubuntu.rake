#!/usr/bin/env rake

desc 'Invoke itamae command for the first time'
task :ubuntu do
  node = `ls -1 nodes/*.json | xargs -I % basename % .json | fzf`
  node.chomp!

  sh "ITAMAE_PASSWORD=musashi bundle ex itamae ssh -u ubuntu -i ~/.ssh/amazon.pem --host #{node} -j nodes/#{node}.json entrypoint.rb"
end
