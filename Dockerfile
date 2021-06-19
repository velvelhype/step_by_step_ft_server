FROM debian:buster

ENV	AUTOINDEX on

RUN apt-get update && apt-get install -y --no-install-recommends \
	nginx wget mariadb-server sysvinit-utils openssl\
	php-fpm \
	php-cgi \
	php-common \
	php-pear \
	php-mysql \
	php-mbstring \
	php-zip \
	php-net-socket \
	php-xml-util \
	php-gettext \
	php-bcmath \
	php-gd  && \
	mkdir /var/www/localhost && \
	cd /var/www/localhost && \
	openssl req -x509 \
	-nodes -days 30 \
	-subj "/C=JP" \
	-newkey rsa:2048 \
	-keyout /etc/ssl/ssl-k.key -out /etc/ssl/ssl-c.crt; 

RUN cd /var/www/localhost && \
	wget --no-check-certificate https://files.phpmyadmin.net/phpMyAdmin/5.1.0/phpMyAdmin-5.1.0-english.tar.gz && \
	tar -xf phpMyAdmin-5.1.0-english.tar.gz && rm -rf phpMyAdmin-5.1.0-english.tar.gz && \
	mv phpMyAdmin-5.1.0-english /var/www/localhost/phpmyadmin && \
	wget --no-check-certificate https://wordpress.org/latest.tar.gz  && \
	tar -xvzf latest.tar.gz && rm -rf latest.tar.gz 

COPY srcs/nginx-config /etc/nginx/sites-available/default
COPY ./srcs/config.inc.php /var/www/localhost/phpmyadmin
COPY ./srcs/wp-config.php /var/www/localhost/wordpress
COPY srcs/launcher.sh /var/www/localhost/

RUN chown -R www-data:www-data /var/www/* && \
	chmod +x /var/www/localhost/launcher.sh

#CMD bash launcher.sh
CMD	echo $AUTOINDEX && \
	sed -ie "s/autoindex on/autoindex $AUTOINDEX/g" /etc/nginx/sites-available/default && \
	bash /var/www/localhost/launcher.sh 

#19 WORKDIR /var/www/localhost