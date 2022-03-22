#!/bin/sh

# cria pastas 
if [ ! -d /data/htdocs ] ; then
 
fi

#  php-fpm logs
mkdir -p /data/logs/php-fpm

# nginx
mkdir -p /data/logs/nginx
mkdir -p /data/logs/php-fpm
mkdir -p /tmp/nginx
chown nginx /tmp/nginx

# inicia sql e cria base de dados padrão se necessário 
# é possível incorporar isso no cakephp mas dessa forma resolve 
if [ ! -f /var/lib/mysql/ibdata1 ]; then
  mysql_install_db --skip-test-db 
  mysqld_safe --skip-grant-tables --user=root --init-file=/tmp/criar-base.sql 
  rm -f /tmp/criar-base.sql
else
  mysqld_safe --skip-grant-tables  --user=root
fi

/usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf