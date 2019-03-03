#!/usr/bin/env rake

desc 'Encrypt the file'
task :encrypt do
  files = `find cookbooks -type f -name 'encrypt_*'`.split("\n")

  files.each do |f|
    from = f
    to = f.sub('encrypt_', '')

    sh "bundle ex reversible_cryptography encrypt --password=musashi --src-file=#{from} --dst-file=#{to}"
  end
end
