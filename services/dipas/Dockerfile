FROM debian:12

RUN apt update && apt upgrade -y
RUN apt install -y php-common libapache2-mod-php php-cli apache2
RUN apt install -y postgresql-client telnet curl wget vim dnsutils lynx

RUN apt install -y composer php-xml php-curl php-gd php-pgsql

RUN wget -O /root/drush.phar https://github.com/drush-ops/drush-launcher/releases/latest/download/drush.phar
RUN chmod +x /root/drush.phar
RUN mv /root/drush.phar /usr/local/bin/drush

RUN touch /etc/php/8.2/apache2/conf.d/99-pg.ini && ln -s /etc/php/8.2/apache2/conf.d/99-pg.ini /etc/php/8.2/mods-available/pg.ini
RUN touch /etc/php/8.2/apache2/conf.d/99-php.ini && ln -s /etc/php/8.2/apache2/conf.d/99-php.ini /etc/php/8.2/mods-available/php.ini
RUN touch /etc/apache2/sites-available/dipas.conf && ln -s /etc/apache2/sites-available/dipas.conf /etc/apache2/sites-enabled/

RUN a2enmod rewrite
