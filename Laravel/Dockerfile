# INstall Ubuntu and nginx for pesbuk
FROM ubuntu:bionic
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get -y update
RUN apt-get install software-properties-common -y
RUN add-apt-repository -y ppa:ondrej/php 
RUN apt-get -y install php mysql-server curl npm
RUN apt install -y openssl php-common php-curl php-json php-mbstring php-mysql php-xml php-zip 

#"----------------Installing PHP Composer---------------"
RUN cd ~/ && curl -sS https://getcomposer.org/installer -o composer-setup.php && php ./composer-setup.php --install-dir=/usr/local/bin --filename=composer 

# "----------------Installing and Creating a Laravel 5.7 Project---------------"
#RUN cd ~/ && composer create-project laravel/laravel --prefer-dist laravel-crud-app
#RUN rm -rf ~/laravel-crud-app

RUN cd ~ && mkdir laravel-crud-app
ADD ./laravel-crud-app ~/laravel-crud-app/
#RUN php artisan -V


# Expose ports.
EXPOSE 80 

#RUN cd ~/laravel-crud-app && php artisan serve --host=172.31.19.127 --port=8000



