#========== UpStream Server ==========
upstream 17orange_shorturl {
	server 10.4.19.219:17000 weight=10;
}
 
#========== Default Server ===========
server
{
    #========== Domain & Port ==========
    listen       80;
    server_name  s.17orange.com;
    
    #========== Settings ==========
    default_type 'text/html';
    charset utf-8;
    
    #========== SSL ==========
    ssl                  off;
    ssl_certificate      /etc/nginx/ssl/1_17orange.com_bundle.crt;
    ssl_certificate_key  /etc/nginx/ssl/2_17orange.com.key;

    ssl_session_timeout  5m;
    
    #========== Service Map ==========    
    location / {
        charset      utf-8;
        proxy_pass   http://17orange_shorturl;

        proxy_redirect          off;
        proxy_set_header        Host $host;
        proxy_set_header        X-Real-IP $remote_addr;
        proxy_set_header        X-Forwarded-For $proxy_add_x_forwarded_for;
    }
        
    #========== Log ==========
    access_log /data/17orange/s/access.log;
    error_log /data/17orange/s/error.log;
}
