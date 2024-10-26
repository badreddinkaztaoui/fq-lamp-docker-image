FROM php:cli-alpine AS builder

RUN apk update && apk add --no-cache --update $PHPIZE_DEPS linux-headers \
	&& docker-php-ext-install pdo_mysql mysqli

FROM php:alpine

RUN apk update && apk add --no-cache --update \
    apache2 \
    apache2-utils \
    mysql \
    mysql-client \
    mariadb \
    mariadb-client \
    && mkdir -p /run/apache2 \
    && mkdir -p /run/mysqld \
    && chown -R mysql:mysql /run/mysqld \
    && mkdir -p /var/lib/mysql \
    && chown -R mysql:mysql /var/lib/mysql

COPY --from=builder /usr/local/lib/php/extensions/ /usr/local/lib/php/extensions/
COPY --from=builder /usr/local/etc/php/conf.d/ /usr/local/etc/php/conf.d/

RUN sed -i 's#^DocumentRoot ".*#DocumentRoot "/var/www/html"#g' /etc/apache2/httpd.conf \
    && sed -i 's#AllowOverride none#AllowOverride All#' /etc/apache2/httpd.conf \
    && sed -i 's#^ServerRoot "/var/www"#ServerRoot "/var/www/html"#g' /etc/apache2/httpd.conf

RUN mkdir -p /var/log/apache2

RUN echo "memory_limit = 256M" > /usr/local/etc/php/conf.d/custom.ini \
    && echo "upload_max_filesize = 64M" >> /usr/local/etc/php/conf.d/custom.ini \
    && echo "post_max_size = 64M" >> /usr/local/etc/php/conf.d/custom.ini

WORKDIR /var/www/html

COPY ./src/ /var/www/html/
COPY ./mysql/ /mysql/
COPY ./run.sh /run.sh

RUN chmod +x /run.sh

EXPOSE 80 3306

CMD ["/run.sh"]
