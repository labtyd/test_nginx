FROM centos

ENV VER_LUA_NGINX_MODULE=0.10.13
ENV VER_NGINX=1.15.0
ENV LUA_NGINX_MODULE lua-nginx-module-${VER_LUA_NGINX_MODULE}
ENV NGINX_ROOT=/nginx
ENV WEB_DIR ${NGINX_ROOT}/html

RUN yum -y install make pcre-devel lua-devel zlib-devel gcc wget

RUN wget http://nginx.org/download/nginx-${VER_NGINX}.tar.gz
RUN wget https://github.com/openresty/lua-nginx-module/archive/v${VER_LUA_NGINX_MODULE}.tar.gz -O ${LUA_NGINX_MODULE}.tar.gz
RUN tar -xzvf nginx-${VER_NGINX}.tar.gz && rm nginx-${VER_NGINX}.tar.gz
RUN tar -xzvf ${LUA_NGINX_MODULE}.tar.gz && rm ${LUA_NGINX_MODULE}.tar.gz

WORKDIR /nginx-${VER_NGINX}
RUN ./configure --prefix=${NGINX_ROOT}  --add-module=../${LUA_NGINX_MODULE}
RUN make -j2
RUN make install
RUN ln -s ${NGINX_ROOT}/sbin/nginx /usr/local/sbin/nginx

WORKDIR ${WEB_DIR}

RUN rm -rf /nginx-${VER_NGINX}
RUN rm -rf /${LUA_NGINX_MODULE}

COPY nginx.conf /nginx/conf/nginx.conf
COPY index.html /nginx/html/index.html

CMD ["nginx", "-g", "daemon off;"]
EXPOSE 80
