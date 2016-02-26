# Version 1.0.0
# cyan.img.Nginx

#========== Basic Image ==========
From nginx:1.9.11
MAINTAINER "DreamInSun"

#========== Expose ==========
ENV NGINX_HOME /etc/nginx
ENV NGINX_DATA /data

#========== Expose ==========
ADD nginx $NGINX_HOME

#========== Expose ==========
#EXPOSE 80
#EXPOSE 443

#========== Expose ==========
VOLUME $NGINX_DATA/sites-enabled
VOLUME $NGINX_DATA/ssl
VOLUME $NGINX_DATA/html
VOLUME $NGINX_DATA/conf.d
VOLUME $NGINX_DATA/log

#========= Add Entry Point ==========
#ADD shell /shell
#RUN chmod a+x /shell/*

#========= Start Service ==========
ENTRYPOINT ["/shell/docker-entrypoint.sh"]
