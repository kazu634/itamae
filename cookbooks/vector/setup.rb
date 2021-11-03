# Create `/var/log/vector`:
%w( /var/log/vector ).each do |d|
  directory d do
    owner  'root'
    group  'root'
    mode   '0755'
  end
end

# Stop vector default service:
service 'vector' do
  action :disable
end
