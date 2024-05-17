# FROM debian:bookworm-slim
FROM php:8.1-apache


WORKDIR /var/www/html

RUN apt-get update && \
    apt-get install -y --no-install-recommends unzip wget ca-certificates git
RUN wget "https://github.com/klaussilveira/gitlist/releases/download/2.0.0/gitlist-2.0.0.zip"
RUN unzip gitlist-2.0.0.zip
# COPY ./config ./config
COPY ./config/config.yml ./config/config.yml

ENV APACHE_DOCUMENT_ROOT /var/www/html/public

#RUN sed -ri -e 's!/var/www/html!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/sites-available/*.conf
#RUN sed -ri -e 's!/var/www/!${APACHE_DOCUMENT_ROOT}!g' /etc/apache2/apache2.conf /etc/apache2/conf-available/*.conf

RUN mkdir -p var/cache  && \
    mkdir -p var/cache && \
    chmod 777 var/cache && \
    mkdir -p var/log && \
    chmod 777 var/log

# RUN git config --global --add safe.directory /home/app/web/config_backup
#RUN git config --global --add safe.directory /var/www/config_backup
# RUN git config --file /var/www/config_backup/.git/config --add safe.directory /var/www/config_backup
# RUN chown -R www-data /home/config_backup
RUN git config --global --add safe.directory /var/www/Config

COPY ./apache.conf /etc/apache2/sites-available/000-default.conf
RUN a2enmod rewrite
RUN a2enmod proxy
RUN a2enmod proxy_http

# USER www-data


# Expose the port Apache listens on
EXPOSE 80

# Start Apache when the container runs
CMD ["apache2-foreground"]