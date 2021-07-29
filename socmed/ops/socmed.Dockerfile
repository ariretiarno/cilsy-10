FROM debian:stretch

ENV DEBIAN_FRONTEND noninteractive

# install NGINX
RUN apt-get update && \
	apt-get install -y nginx --no-install-recommends && \
	rm -rf /var/lib/apt/lists/*

# install
RUN apt-get update
RUN apt-get install -y \
     git \
     apt-transport-https \
     ca-certificates \
     curl \
     gnupg\
     software-properties-common 
RUN rm -rf /var/lib/apt/lists/*

RUN curl https://packages.sury.org/php/apt.gpg | apt-key add -
RUN echo 'deb https://packages.sury.org/php/ stretch main' > /etc/apt/sources.list.d/deb.sury.org.list

# install PHP 7.2
RUN apt-get update && \
	apt-get install -y php7.2-fpm php7.2-cli php7.2-common php7.2-opcache php7.2-curl php7.2-mbstring php7.2-zip php7.2-xml php7.2-gd php7.2-mysql --no-install-recommends && \
	rm -rf /var/lib/apt/lists/*
RUN useradd -ms /bin/bash nginx
# supervisory
RUN apt-get update && \
	apt-get install -y supervisor --no-install-recommends && \
	rm -rf /var/lib/apt/lists/*
COPY ops/supervisor.conf /etc/supervisor/supervisord.conf
RUN mkdir /run/php && mkdir -p /var/www/apps

COPY . /var/www/apps/
COPY ops/www.conf /etc/php/7.2/fpm/pool.d/
COPY ops/php7proxy /etc/nginx/php7proxy
COPY ops/nginx.conf /etc/nginx/
COPY ops/apps.conf /etc/nginx/conf.d/apps.conf
COPY ops/php.ini /etc/php/7.2/fpm

EXPOSE 8000
CMD ["supervisord", "-c", "/etc/supervisor/supervisord.conf"]

