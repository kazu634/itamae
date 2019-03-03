# Calculate the latest peco version:
nvm_url = ''

begin
  require 'net/http'

  uri = URI.parse('https://github.com/creationix/nvm/releases/latest')

  Timeout.timeout(3) do
    response = Net::HTTP.get_response(uri)

    vtag = $1 if response.body =~ %r{tag\/(v\d+\.\d+\.\d+)}

    nvm_url = "#{node['nvm']['url_prefix']}/#{vtag}/#{node['nvm']['url_postfix']}"
  end
rescue
  # Abort the chef client process:
  raise 'Cannot connect to http://github.com.'
end

execute "wget -qO- #{nvm_url} | bash" do
  user 'wekan'
  cwd '/home/wekan'

  not_if 'test -e /home/wekan/.nvm'
end

ver = node['nvm']['node_version']

execute "su - wekan -c '. /home/wekan/.nvm/nvm.sh; nvm install #{ver}'" do
  cwd '/home/wekan'

  not_if "test -e /home/wekan/.nvm/versions/node/#{ver}"
end

execute "su - wekan -c '. /home/wekan/.nvm/nvm.sh; nvm use #{ver}'" do
  cwd '/home/wekan'
end
