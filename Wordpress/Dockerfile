# INstall Ubuntu and nginx for pesbuk
FROM ubuntu:bionic
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update
#RUN apt-get install -y mysql-server 
RUN apt-get install -y nginx php-fpm php-mysqli unzip
RUN apt install -y curl php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip 
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN sed -i -e "s/;\?daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.2/fpm/php-fpm.conf

#Mysql
#RUN mysql -u root -e "CREATE DATABASE IF NOT EXISTS wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci; GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'password'; FLUSH PRIVILEGES;"
# RUN mysql -u root -e "CREATE DATABASE IF NOT EXISTS wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;"
# RUN mysql -u root -e "GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'password';"
# RUN mysql -u root -e "FLUSH PRIVILEGES;"

# RUN mysql -u root << EOF\
#     CREATE DATABASE IF NOT EXISTS wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;\
#     GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'password';\
#     FLUSH PRIVILEGES;\
#     EOF

#COPY FILE
RUN cd /tmp && curl -LO https://wordpress.org/latest.tar.gz && tar xzvf latest.tar.gz
RUN cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
RUN mkdir /var/www/wordpress
RUN cp -a /tmp/wordpress/. /var/www/wordpress
RUN chown -R www-data:www-data /var/www/wordpress
RUN curl -s https://api.wordpress.org/secret-key/1.1/salt/
RUN sed -i 's/put your unique phrase here/VALUES COPIED FROM THE COMMAND LINE/g' /var/www/wordpress/wp-config.php
RUN sed -i 's/database_name_here/wordpress/g' /var/www/wordpress/wp-config.php
RUN sed -i 's/username_here/wordpressuser/g' /var/www/wordpress/wp-config.php
RUN sed -i 's/password_here/password/g' /var/www/wordpress/wp-config.php
RUN sed -i 's/localhost/13.212.212.202/g' /var/www/wordpress/wp-config.php

RUN echo 'define('FS_METHOD', 'direct');' >> RUN /var/www/wordpress/wp-config.php
# Nginx config
RUN rm /etc/nginx/sites-enabled/default
ADD ./wordpress /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled/

# Expose ports.
EXPOSE 80

# RUN PHP and NGINX
CMD service php7.2-fpm start && nginx

