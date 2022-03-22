FROM alpine:3.14
LABEL maintainer="Job Diogenes<jobdiogenes@gmail.com>"
LABEL version="latest"

ENV TERM xterm
ENV RELEASE="v_1.1.2"

RUN apk add --update curl mysql mysql-client curl nginx \
        php php-intl php-mbstring php-simplexml php-openssl php-json php-phar \
        supervisor ca-certificates &&\
    mkdir -p /var/lib/mysql && \
    mkdir -p /etc/mysql/conf.d && \
    mkdir -p /etc/nginx/conf.d && \
    mkdir -p /var/run/mysql/ && \
    mkdir -p /data/www && \
    chown :www-data /data/www &&\
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/bin --filename=composer && \
    rm -rf /var/cache/apk/*

COPY files/nginx.conf /etc/nginx/
COPY files/php-fpm.conf /etc/php/
COPY files/my.cnf /etc/mysql/
COPY files/default.conf /etc/nginx/conf.d/
COPY files/iniciar.sh /

RUN curl -L https://github.com/jobdiogenes/rh/archive/refs/tags/${RELEASE}.tar.gz -o  /tmp/rh-cake.tar.gz &&\
    tar -xvzf /tmp/rh-cake.tar.gz --strip 1 -C /data/www &&\
    cd /data/www && \
    composer install && \
    cd / &&\
    chmod +x /iniciar.sh 

EXPOSE 80
EXPOSE 3306
WORKDIR /data/htdocs
VOLUME ["/data/www", "/data/logs", "/var/lib/mysql", "/etc/mysql/conf.d/"]

CMD ["/iniciar.sh"]
