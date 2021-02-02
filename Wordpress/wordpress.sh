sudo apt-get update
sudo apt install mysql-server -y
sudo apt install php-curl php-gd php-intl php-mbstring php-soap php-xml php-xmlrpc php-zip -y
sudo apt install php-fpm -y
sudo apt install nginx -y
sudo apt-get install -y php-mysqli 
sudo apt-get install unzip

sudo mysql -u root << EOF
CREATE DATABASE IF NOT EXISTS wordpress DEFAULT CHARACTER SET utf8 COLLATE utf8_unicode_ci;
#CREATE USER IF NOT EXISTS 'wordpressuser'@'localhost' IDENTIFIED BY 'password';
#GRANT ALL PRIVILEGES ON * . * TO 'wordpressuser'@'localhost';
GRANT ALL ON wordpress.* TO 'wordpressuser'@'localhost' IDENTIFIED BY 'password';
FLUSH PRIVILEGES;
EOF

var1=$(dig +short myip.opendns.com @resolver1.opendns.com)
echo "----------------Setting Nginx---------------"
sudo tee /etc/nginx/sites-available/wordpress <<EOL
server {
	listen 80;
	#bisa diganti dengan ip address localhostmu atau ip servermu, nanti kalau sudah ada domain diganti nama domainmu
	server_name $var1;
	#root adalah tempat dmn codingannya di masukkan index.html dll.
	root /var/www/wordpress;
	
	# Add index.php to the list if you are using PHP
	index index.php index.html index.htm ;

    location ~ \.php$ {
	    include snippets/fastcgi-php.conf;
	    fastcgi_pass unix:/var/run/php/php7.2-fpm.sock;
	}

	location ~ /\.ht {
	    deny all;
	}
	location = /favicon.ico { log_not_found off; access_log off; }
    location = /robots.txt { log_not_found off; access_log off; allow all; }
    location ~* \.(css|gif|ico|jpeg|jpg|js|png)$ {
        expires max;
        log_not_found off;
    }
    location / {
        #try_files $uri $uri/ =404;
        try_files \$uri \$uri/ /index.php$is_args$args;
    }
	
}
EOL
sudo ln -s /etc/nginx/sites-available/wordpress /etc/nginx/sites-enabled
sudo unlink /etc/nginx/sites-enabled/default

echo "----------------Review & Start Nginx---------------"
sudo nginx -t
#setelah update data harus dicek dengan restart nginx-t dulu sebelum restart nginx
sudo systemctl restart nginx

echo "----------------Downloading WordPress---------------"
cd /tmp && curl -LO https://wordpress.org/latest.tar.gz && tar xzvf latest.tar.gz
cp /tmp/wordpress/wp-config-sample.php /tmp/wordpress/wp-config.php
sudo mkdir /var/www/wordpress
sudo cp -a /tmp/wordpress/. /var/www/wordpress
sudo chown -R www-data:www-data /var/www/wordpress
curl -s https://api.wordpress.org/secret-key/1.1/salt/
#sudo nano /var/www/wordpress/wp-config.php
sudo sed -i 's/put your unique phrase here/VALUES COPIED FROM THE COMMAND LINE/g' /var/www/wordpress/wp-config.php
sudo sed -i 's/database_name_her/wordpress/g' /var/www/wordpress/wp-config.php
sudo sed -i 's/username_here/wordpressuser/g' /var/www/wordpress/wp-config.php
sudo sed -i 's/password_here/password/g' /var/www/wordpress/wp-config.php
echo 'define('FS_METHOD', 'direct');' >> sudo /var/www/wordpress/wp-config.php

# Kalo pai external mysql jangan lupa "bind-address = 0.0.0.0" di sudo nano /etc/mysql/mysql.conf.d/mysqld.cnf lalu sudo systemctl restart mysql






