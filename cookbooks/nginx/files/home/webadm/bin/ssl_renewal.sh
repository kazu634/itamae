#!/bin/bash

# Preparation for maintenance:
rm -f /etc/nginx/sites-enabled/*
ln -s /etc/nginx/sites-available/maintenance /etc/nginx/sites-enabled/maintenance

# Start maintenance:
touch /tmp/maintenance

# Reload `nginx` configuration:
systemctl reload nginx

# Renewal SSL certificate:
certbot renew

sleep 5

# Stop maintenance:
rm /tmp/maintenance

# Preparation for normal operation:
rm -f /etc/nginx/sites-enabled/maintenance

for conf in $(find /etc/nginx/sites-available -maxdepth 1 -type f | grep -v maintenance); do
  ln -s "${conf}" "/etc/nginx/sites-enabled/${conf/\/etc\/nginx\/sites-available\//}"
done

# Reload `nginx` configuration:
systemctl reload nginx

exit 0
