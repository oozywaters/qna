FROM phusion/passenger-ruby25
MAINTAINER oozywaters "oozy.waters@gmail.com"

ENV HOME /root
ENV RAILS_ENV production

CMD ["/sbin/my_init"]

RUN rm -f /etc/service/nginx/down
RUN rm /etc/nginx/sites-enabled/default
ADD nginx.conf /etc/nginx/sites-enabled/qna_website.conf

ADD . /home/app/qna
WORKDIR /home/app/qna
RUN chown -R app:app /home/app/qna
RUN sudo -u app bundle install --deployment
RUN sudo -u app RAILS_ENV=production rake assets:precompile

RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*
