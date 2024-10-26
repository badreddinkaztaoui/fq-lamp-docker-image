#!/bin/sh

if [ ! -d "/var/lib/mysql/mysql" ]; then
	mysql_install_db --user=mysql --datadir=/var/lib/mysql
fi

mysqld --user=mysql --datadir=/var/lib/mysql &

while ! mysqladmin ping -h localhost --silent; do
	sleep 1
done

if [ -f "/mysql/init.sql" ]; then
	mysql < /mysql/init.sql
fi

httpd -D FOREGROUND
