#!/bin/sh
echo ========== Set Up Environment ==========
echo NGINX_HOME is $NGINX_HOME
echo NGINX_DATA is $NGINX_DATA

echo ========== Set Up Environment ==========
mkdir -p $NGINX_HOME/log

echo ========== Start Nginx ==========
nginx -g 'daemon off;'