FROM phusion/passenger-ruby25
MAINTAINER oozywaters "oozy.waters@gmail.com"

ENV HOME /root
ENV RAILS_ENV production

CMD ["/sbin/my_init"]

RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
ADD config/nginx.conf /etc/nginx/sites-enabled/qna_website.conf
# Add the rails-env configuration file
ADD config/rails-env.conf /etc/nginx/main.d/rails-env.conf
ADD config/postgres-env.conf /etc/nginx/main.d/postgres-env.conf

RUN apt-get update && apt-get install -y tzdata sudo

ADD . /home/app/qna
WORKDIR /home/app/qna
RUN chown -R app:app /home/app/qna
RUN sudo -u app bundle install --deployment
RUN sudo -u app RAILS_ENV=production SECRET_KEY_BASE=token rake assets:precompile

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENTRYPOINT ["bin/entry"]

EXPOSE 80
