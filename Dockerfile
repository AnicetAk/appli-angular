FROM nginx:1.25.1-alpine3.17
WORKDIR /usr/share/nginx/html
COPY /dist /usr/share/nginx/html/
RUN rm /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/conf.d
EXPOSE 80
