FROM nginx:stable-alpine3.17-slim
WORKDIR /usr/share/nginx/html
COPY . .
EXPOSE 80
