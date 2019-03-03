# Language Settings:
package 'language-pack-ja-base'

execute 'locale-gen ja_JP.UTF-8' do
  user 'root'

  not_if 'locale -a | grep ja_JP.utf8'
end

execute 'dpkg-reconfigure --frontend=noninteractive locales' do
  user 'root'

  not_if 'locale -a | grep ja_JP.utf8'
end

execute 'update-locale LANG=ja_JP.UTF-8' do
  user 'root'

  not_if 'strings /etc/default/locale | grep ja_JP.UTF-8'
end
