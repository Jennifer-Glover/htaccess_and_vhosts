FROM ubuntu:latest
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update
RUN apt-get install -y sudo
RUN apt-get install -y vim
RUN apt-get install -y curl
RUN apt-get install -y wget
RUN apt-get install -y apache2
RUN apt-get install -y apache2-utils
RUN apt-get clean 
RUN apt-get update

RUN a2enmod userdir
RUN a2enmod autoindex

RUN sudo adduser --force-badname --disabled-password --gecos "" user

RUN cd /home/user
RUN mkdir public_html
RUN chmod 755 public_html
WORKDIR /home/user/public_html
COPY user.html .
RUN mv user.html index.html

WORKDIR /home/user/public_html
RUN mkdir Dev
RUN chmod 755 Dev
WORKDIR /home/user/public_html/Dev
COPY userinfo.html .
RUN mv userinfo.html index.html

WORKDIR /home/

RUN htpasswd -b -c /home/user/public_html/Dev/.htpasswd user pass
WORKDIR /home/user/public_html/Dev
COPY htaccess .
RUN mv htaccess .htaccess

WORKDIR /var/www/html
RUN mkdir -p /var/www/html/site1/public_html
RUN chown -R $USER:$USER /var/www/html/site1/public_html
RUN sudo chmod -R 755 /var/www/html
WORKDIR /var/www/html/site1/public_html
COPY site1.html .
RUN mv site1.html index.html 
WORKDIR /etc/apache2/sites-enabled
COPY site1.conf .

WORKDIR /var/www/html
RUN mkdir -p /var/www/html/site2/public_html
RUN chown -R $USER:$USER /var/www/html/site2/public_html
RUN sudo chmod -R 755 /var/www/html
WORKDIR /var/www/html/site2/public_html
COPY site2.html .
RUN mv site2.html index.html 
WORKDIR /etc/apache2/sites-enabled
COPY site2.conf .

WORKDIR /var/www/html
RUN mkdir -p /var/www/html/site3/public_html
RUN chown -R $USER:$USER /var/www/html/site3/public_html
RUN sudo chmod -R 755 /var/www/html
WORKDIR /var/www/html/site3/public_html
COPY site3.html .
RUN mv site3.html index.html 
WORKDIR /etc/apache2/sites-enabled
COPY site3.conf .

RUN sudo a2dissite 000-default.conf

CMD ["/usr/sbin/apache2ctl", "-D", "FOREGROUND"]

RUN service apache2 restart