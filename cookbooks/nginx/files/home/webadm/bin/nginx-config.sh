#!/bin/bash

# Preparation for normal operation:
rm -f /etc/nginx/sites-enabled/maintenance

for conf in $(find /etc/nginx/sites-available -maxdepth 1 -type f | grep -v maintenance); do
  ln -s "${conf}" "/etc/nginx/sites-enabled/${conf/\/etc\/nginx\/sites-available\//}"
done

# Reload `nginx` configuration:
/bin/systemctl reload nginx

exit 0
