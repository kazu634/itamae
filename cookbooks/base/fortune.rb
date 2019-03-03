# Install `fortune` package:
package 'fortune' do
  not_if 'test -e /usr/games/fortune'
end

URL='http://www.splitbrain.org/_media/projects/fortunes/fortune-starwars.tgz'
TGZ='fortune-starwars.tgz'

[
  "wget #{URL} -O #{TGZ}",
  "tar xf #{TGZ}",
  'cp fortune-starwars/starwars.dat /usr/share/games/fortunes/',
  'cp fortune-starwars/starwars /usr/share/games/fortunes/'
].each do |cmd|
  execute cmd do
    user 'root'
    cwd '/tmp/itamae_tmp/'

    not_if 'test -e /usr/share/games/fortunes/starwars.dat'
  end
end
