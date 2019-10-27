# ---
# Variables & Constants
USER        = 'webadm'
GROUP       = 'webadm'

WORKDIR     = '/home/webadm/nginx-build/'
MODULEDIR   = "#{WORKDIR}/modules/"
TARBALL     = '/home/webadm/nginx-build/nginx-build.tar.gz'
NGINXBUILD  = '/home/webadm/nginx-build/nginx-build'

version     = node['nginx']['version']

vtag        = ''
tag_version = ''
nginxbuild  = ''
# ---

%w( libgeoip-dev ).each do |p|
  package p do
    action :install
  end
end

directory WORKDIR do
  owner USER
  group GROUP
  mode '755'
end

# -------------------------------------------
# Calculating the latest `nginx-build` version:
# -------------------------------------------
begin
  require 'net/http'

  uri = URI.parse('https://github.com/cubicdaiya/nginx-build/releases/latest')

  Timeout.timeout(3) do
    response = Net::HTTP.get_response(uri)

    if response.body =~ %r{tag\/(v\d+\.\d+\.\d+)}
      vtag        = $1
      tag_version = vtag.sub('v', '')

      nginxbuild = "https://github.com/cubicdaiya/nginx-build/releases/download/#{vtag}/nginx-build-linux-amd64-#{tag_version}.tar.gz"
    end
  end
rescue
  # Abort the chef client process:
  raise 'Cannot connect to http://github.com.'
end

# Download `nginx-build`:
execute "wget #{nginxbuild} -O #{TARBALL}"

execute "tar xf #{TARBALL} && chown webadm:webadm #{NGINXBUILD}" do
  user USER
  cwd WORKDIR
end

# Deploy `configure.sh`:
remote_file "#{WORKDIR}/configure.sh" do
  owner USER
  group GROUP
  mode '755'
end

# Add the nginx modules, if any:
directory MODULEDIR do
  owner USER
  group GROUP
  mode '755'
end

# Build starts here:
execute "#{NGINXBUILD} -d working -v #{version} -c configure.sh -zlib -pcre -openssl -opensslversion=1.1.1d" do
  cwd WORKDIR
  user USER

  not_if "test -e #{WORKDIR}/working/nginx/#{version}/nginx-#{version}/objs"
end

# make install here:
execute 'make install' do
  user 'root'
  cwd "#{WORKDIR}/working/nginx/#{version}/nginx-#{version}/"

  not_if "/usr/share/nginx/sbin/nginx -v 2>&1 | grep #{version}"
end
