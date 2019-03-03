include_recipe './attributes.rb'

# Calculate the latest peco version:
peco_url = ''

begin
  require 'net/http'

  uri = URI.parse('https://github.com/peco/peco/releases/latest')

  Timeout.timeout(3) do
    response = Net::HTTP.get_response(uri)

    vtag = $1 if response.body =~ %r{tag\/(v\d+\.\d+\.\d+)}

    peco_url = "#{node['peco']['url']}/#{vtag}/#{node['peco']['tarball']}"
  end
rescue
  # Abort the chef client process:
  raise 'Cannot connect to http://github.com.'
end

# Download:
TMP = "/tmp/#{node['peco']['tarball']}"

execute "wget #{peco_url} -O #{TMP}"

# Install:
INSTALLDIR = '/opt/peco/bin/'
TARGETDIR = '/usr/local/bin/'

directory INSTALLDIR do
  action :create
end

execute "tar zxf #{TMP} -C #{INSTALLDIR} --strip-components 1" do
  action :run
end

# Make a symlink:
link "#{TARGETDIR}/peco" do
  user 'root'
  to "#{INSTALLDIR}/peco"
  force true
end
