# Version 2.2.3
# cyan.svc.Nginx

#========== Basic Image ==========
From nginx:1.13.7
MAINTAINER "DreamInSun"

#========== Override Nginx File ==========
ENV NGINX_HOME /etc/nginx
ADD nginx $NGINX_HOME 

#========== Install Telnet ==========
RUN apt-get update && apt-get install -qqy telnet 

#========== Install NGINX Amplify Agent ==========
RUN apt-get update \
    && apt-get install -qqy curl python apt-transport-https apt-utils gnupg1 procps \
    && echo 'deb https://packages.amplify.nginx.com/debian/ stretch amplify-agent' > /etc/apt/sources.list.d/nginx-amplify.list \
    && curl -fs https://nginx.org/keys/nginx_signing.key | apt-key add - > /dev/null 2>&1 \
    && apt-get update \
    && apt-get install -qqy nginx-amplify-agent \
    && apt-get purge -qqy curl apt-transport-https apt-utils gnupg1 \
    && rm -rf /var/lib/apt/lists/*

#========== Install ==========
# ADD install /install
# WORKDIR /install
# RUN unzip ./consul-template_0.19.5_linux_amd64.zip && mv ./consul-template /usr/bin/
# RUN rm -rf /install
	
#========== Log ==========
# Keep the nginx logs inside the container
RUN unlink /var/log/nginx/access.log \
    && unlink /var/log/nginx/error.log \
    && touch /var/log/nginx/access.log \
    && touch /var/log/nginx/error.log \
    && chown nginx /var/log/nginx/*log \
    && chmod 644 /var/log/nginx/*log

	
#===== amplify ======
# Copy nginx stub_status config
# COPY ./amplify/conf.d/stub_status.conf /etc/nginx/conf.d 

# ENV API_KEY 1234567890 
# ENV AMPLIFY_IMAGENAME my-docker-instance-123

# The /entrypoint.sh script will launch nginx and the Amplify Agent.
# The script honors API_KEY and AMPLIFY_IMAGENAME environment
# variables, and updates /etc/amplify-agent/agent.conf accordingly.


#========== Expose ==========
EXPOSE 80
EXPOSE 443
EXPOSE 8080
EXPOSE 8443

#========== Expose ==========
VOLUME $NGINX_HOME/sites-enabled
VOLUME $NGINX_HOME/stream-enabled
VOLUME $NGINX_HOME/ssl
VOLUME $NGINX_HOME/pages
VOLUME $NGINX_HOME/conf.d
VOLUME $NGINX_HOME/log

#========= Add Entry Point ==========
ADD shell /shell
RUN chmod a+x /shell/*

#========= Start Service ==========
#ENTRYPOINT ["/shell/amplify-entrypoint.sh"]

#运行consul ： consul-template --consul-addr 192.168.188.182:8500 --template "./nginx.ctmpl:vhost.conf:/usr/local/nginx/sbin/nginx -s reload" --log-level=info 
ENTRYPOINT ["/shell/docker-entrypoint.sh"]
CMD ["nginx","-g","daemon off;"]
