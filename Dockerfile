FROM cheggwpt/rbenv:0.0.2

MAINTAINER jgilley@chegg.com

# We're just adding an NGINX layer here, so inheriting expose and env vars
# from upstream

# install nginx as a layer 
RUN	apk --update --no-cache add \
	nginx && \
	rm -rf /var/cache/apk/*

# Add the www-data user and group, fail on error
RUN set -x ; \
	addgroup -g 82 -S www-data ; \
	adduser -u 82 -D -S -G www-data www-data && exit 0 ; exit 1

# remove the default nginx config;
# set up the run lock location and user;
# make /app group www-data
# add the group R&W permissions
RUN rm -rf /etc/nginx/conf.d/default.conf && \
	mkdir -p /run/nginx && \
	chown -R nginx:www-data /run/nginx && \
	chown -R :www-data /app && \
	chmod -R g+rw /app

# Add the container config files
COPY container_confs /
