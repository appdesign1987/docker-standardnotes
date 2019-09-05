FROM node:6-alpine

RUN apk -U upgrade \
    && apk add -t build-dependencies \
    git \
    linux-headers \
    curl-dev \
    wget \
    ruby-dev \
    build-base \ 
    && apk add \
    tzdata \
    ruby \
    ruby-io-console \
    ruby-json \
    ruby-bigdecimal \
  && git clone https://github.com/standardnotes/web.git /standardnotes \
  && gem install -N rails --version "$RAILS_VERSION" \
  && echo 'gem: --no-document' >> ~/.gemrc \
  && cp ~/.gemrc /etc/gemrc \
  && chmod uog+r /etc/gemrc \
  && rm -rf ~/.gem \
  && cd /standardnotes \
  && gem install bundler:1.17.1 \
  && bundle config --global silence_root_warning 1 \
  && npm install \
  && npm install -g bower grunt \
  && bundle exec rake bower:install \
  && grunt \
  && apk del build-dependencies \
  && rm -rf /tmp/*  /var/cache/apk/* /tmp/* /root/.gnupg /root/.cache/ /standardnotes/.git 

COPY docker /docker

EXPOSE 3000
ENTRYPOINT ["/docker/entrypoint"]
CMD ["start"]

