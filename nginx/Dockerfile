FROM nginx:1.25

RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d

#COPY setup.sh .
#RUN ./setup.sh

#RUN git config --global --add safe.directory /home/app/web/config_backup
#RUN git config --global --add safe.directory /var/www/config_backup