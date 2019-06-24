FROM nginx:alpine
LABEL description="NGINX Docker on Alpine Linux for OTUS"
RUN apk --no-cache upgrade
ADD https://raw.githubusercontent.com/WildWay/otus-linux/master/tasks/module_2/10_Docker/latest/config/nginx.conf /etc/nginx.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]