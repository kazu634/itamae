#!/bin/bash

./configure --with-cc-opt='-g -O2 -fPIE -fstack-protector --param=ssp-buffer-size=4 -Wformat -Werror=format-security -D_FORTIFY_SOURCE=2' \
            --prefix=/usr/share/nginx --conf-path=/etc/nginx/nginx.conf --http-log-path=/var/log/nginx/access.log \
            --error-log-path=/var/log/nginx/error.log  --lock-path=/var/lock/nginx.lock --pid-path=/run/nginx.pid \
            --http-client-body-temp-path=/var/lib/nginx/body --http-fastcgi-temp-path=/var/lib/nginx/fastcgi \
            --http-proxy-temp-path=/var/lib/nginx/proxy --http-scgi-temp-path=/var/lib/nginx/scgi \
            --http-uwsgi-temp-path=/var/lib/nginx/uwsgi --with-debug --with-pcre-jit --with-ipv6 --with-http_ssl_module \
            --with-http_v2_module --with-http_stub_status_module --with-http_realip_module --with-http_auth_request_module \
            --with-http_addition_module --with-http_geoip_module --with-http_gunzip_module --with-http_gzip_static_module \
            --with-http_sub_module --with-stream --with-stream_ssl_module
