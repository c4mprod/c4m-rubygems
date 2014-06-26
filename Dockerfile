FROM phusion/passenger-ruby21:0.9.11
MAINTAINER Cedric Darne <cedric.darne@c4mprod.com>

# Set correct environment variables.
ENV HOME /root

# Use baseimage-docker's init process.
CMD ["/sbin/my_init"]

# Enable passenger
RUN rm -f /etc/service/nginx/down
RUN rm -f /etc/nginx/sites-enabled/default

ADD conf/webapp.conf /etc/nginx/sites-enabled/webapp.conf
ADD conf/webapp-env.conf /etc/nginx/main.d/webapp-env.conf
ADD . /home/app/webapp/
RUN chown -R app:app /home/app/webapp

USER app
WORKDIR /home/app/webapp
RUN bundle install --without development:test --path vendor/bundle --binstubs vendor/bundle/bin --deployment

USER root

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
