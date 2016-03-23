upstream tomcat1{
    server localhost:8081 weight=10;
    ip_hash;
}

upstream tomcat2{
    server localhost:8082 weight=10;
#    server 10.4.48.219:8080 weight=10;
    ip_hash;
}

#========== Default Server ===========
server {
    listen       8080;
    server_name  api.17orange.com;

    #========== Settings ==========
    default_type 'text/html';
    charset utf-8;

    #========== SSL ==========
    ssl                  off;
    #ssl_certificate      /etc/nginx/ssl/1_17orange.com_bundle.crt;
    #ssl_certificate_key  /etc/nginx/ssl/2_17orange.com.key;

    ssl_session_timeout  5m;


    proxy_redirect  off;
    proxy_set_header    Host            $host;
    proxy_set_header    X-Real-IP       $remote_addr;
    proxy_set_header    X-Forwarded-For $proxy_add_x_forwarded_for;


#    log_format syslog '$remote_addr|$host|$request_uri|$status|$request_time|$body_bytes_sent|'
#                  '$upstream_addr|$upstream_status|$upstream_response_time|'
#                  '$http_referrer|$http_add_x_forwarded_for|$http_user_agent';    
    access_log      /data/nginx/log/api-orange-com-access.log syslog;

    location = /favicon.ico {
        log_not_found  off;
        root    /var/www/home;
    }

    #========== Service Map ==========
    location ^~ /orangelife_api {
        proxy_pass      http://tomcat1;
    }
        
    location ^~ /payMent_api{
        proxy_pass      http://tomcat1;
    }
    
    location ^~ /order_api{
        proxy_pass      http://tomcat1;
    }
    
    location ^~ /goods_api{
        proxy_pass      http://tomcat1;
    }
    
    location ^~ /merchant_api{
        proxy_pass      http://tomcat1;
    }
    
    location ^~ /orangelife_repair_api{
        proxy_pass      http://tomcat1;
    }
    
    location ^~ /PropMngmComp{
        proxy_pass      http://tomcat1;
    }

    location ^~ /balance_api{
        proxy_pass      http://tomcat2;
    }
    
    #========== Service Map Tomcat 2 =========
    location ^~ /parkmngm_api {
        proxy_pass      http://tomcat2;
    }
        
    location ^~ /HouseClean {
        proxy_pass      http://tomcat2;
    }
    
    location ^~ /message_api{
        proxy_pass      http://tomcat2;
    }
    
    location ^~ /integration_api{
        proxy_pass      http://tomcat2;
    }
    
    location ^~ /propInfo_api{
        proxy_pass      http://tomcat2;
    }
    
    location ^~ /Gatemgt{
        proxy_pass      http://tomcat2;
    }
    
    location ^~ /ucenter-stateless{
        proxy_pass      http://tomcat2;
    }
    
    location ^~ /wallet_api{
        proxy_pass      http://tomcat2;
    }
    
    #========== Web Server ==========
    location ^~ /orangelife_web{
        if (-d $request_filename){
            rewrite ^/(.*)(orangelife_web)([^/])$ http://$host/$1$2/ permanent;
        }
        proxy_pass      http://tomcat2;
    }
    
    location ^~ /prop_web{
        if (-d $request_filename){
            rewrite ^/(.*)(prop_web)([^/])$ http://$host/$1$2/ permanent;
        }
        proxy_pass      http://tomcat2;
    }
    
    location ^~ /repair_web{
        if (-d $request_filename){
            rewrite ^/(.*)(repair_web)([^/])$ http://$host/$1$2/ permanent;
        }
        proxy_pass      http://tomcat2;
    }
    
    location ^~ /clean_web{
        if (-d $request_filename){
            rewrite ^/(.*)(clean_web)([^/])$ http://$host/$1$2/ permanent;
        }
        proxy_pass      http://tomcat2;
    }
    
    location ^~ /market_web{
        if (-d $request_filename){
            rewrite ^/(.*)(market_web)([^/])$ http://$host/$1$2/ permanent;
        }
        proxy_pass      http://tomcat2;
    }
    
    #========== Default Server ==========
    location ^~ / {
        proxy_pass      http://tomcat1;
        #return 503;
    }
    
    #========== UpStream Server ==========
    location @tomcat1 {
        access_log      off;
        internal;
        proxy_pass      http://127.0.0.1:8081;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Via “s9/nginx”;
    }
        
    location @tomcat2 {
        access_log      off;
        internal;
        proxy_pass      http://127.0.0.1:8082;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Via “s9/nginx”;
    }
        
    #========== Log ==========
    #access_log /etc/nginx/log/17orange/api/access.log;
}

