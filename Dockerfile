# INstall Ubuntu and nginx for pesbuk
FROM ubuntu:bionic
RUN apt-get update
RUN apt-get install -y nginx php-fpm mysql-server php-mysql unzip
RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf
RUN sed -i -e "s/;\?daemonize\s*=\s*yes/daemonize = no/g" /etc/php/7.2/fpm/php-$

#COPY FILE
COPY ./sosial-media-master/ /var/www/html/

# Nginx config
RUN rm /etc/nginx/sites-enabled/default
ADD ./web_baru /etc/nginx/sites-available/
RUN ln -s /etc/nginx/sites-available/web_baru /etc/nginx/sites-enabled/

# Expose ports.
EXPOSE 80

# RUN PHP and NGINX
CMD service php7.2-fpm start && nginx

