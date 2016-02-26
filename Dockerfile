# Version 1.0.0
# cyan.img.Nginx

#========== Basic Image ==========
From nginx:1.9.11
MAINTAINER "DreamInSun"

#========== Expose ==========
ENV NGINX_HOME /usr/share/nginx
#========== Expose ==========
ADD nginx $NGINX_HOME

#========== Expose ==========
EXPOSE 80


#========== Expose ==========
VOLUME $NGINX_HOME/sites-enabled
VOLUME $NGINX_HOME/ssl
VOLUME $NGINX_HOME/html
VOLUME $NGINX_HOME/conf

#========= Add Entry Point ==========
#ADD shell /shell
#RUN chmod a+x /shell/*

#========= Start Service ==========
ENTRYPOINT ["/shell/docker-entrypoint.sh"]
