FROM phusion/passenger-ruby25:latest
MAINTAINER Dockerized Rails App

ENV HOME /root
ENV RAILS_ENV production

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]
#COPY rails-app.conf /etc/nginx/conf.d/default.conf

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
