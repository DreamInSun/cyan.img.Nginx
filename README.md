# cyan.svc.Nginx
优化定制Nginx服务

====================
## 功能特性


### 基础镜像
https://hub.docker.com/_/nginx/

### 更多模块
https://www.nginx.com/resources/wiki/modules/

====================
## 部署脚本

'''
cyan-core-Nginx:
  image: daocloud.io/xmhjy/cyan-svc-nginx
  privileged: false
  restart: always
  ports:
  - 80:80
  - 8080:8080
  - 443:443
  volumes:
  - /etc/nginx/log:${HOST_NGINX_PATH}/log
  - /etc/nginx/sites-enabled:${HOST_NGINX_PATH}/sites-enabled
  - /etc/nginx/html:${HOST_NGINX_PATH}/html
'''

###
端口说明：
|端口 |发布类型 |服务类型   |
|:----|:--------|:----------|
|80   |正式发布 | http服务  |
|443  |正式发布 | https服务 |
|8080 |测试发布 | http服务  |
|8443 |测试发布 | https服务 |


====================
## 配置文件

#### 配置文件存放路径
宿主机路径，例如：${HOST_NGINX_PATH}/sites-enabled

### 命名规则
e.g.对demo.cyan.org.cn:80端口的服务,配置文件名为 demo.cyan.org.cn.80.conf

====================
## 内置页面
宿主机路径：${HOST_NGINX_PATH}/html

====================
## 日志文件
宿主机路径：${HOST_NGINX_PATH}/log


====================
## 更新历史

### 1.0.0 
优化文件结构和基本配置
扩展了MIME设置

### 2.2.3
增加了nginx-upsync-module插件,配合etcd/consul等服务发现
https://github.com/weibocom/nginx-upsync-module

增加了Amplify功能
https://github.com/nginxinc/docker-nginx-amplify

### 2.3.0
默认配置增加了WebSocket反向代理

### 2.3.1
暂时移除Consule组件

### 2.3.2
修正Docker脚本错误