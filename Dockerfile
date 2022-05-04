FROM ruby:3.1
ARG UNAME=app
ARG UID=1000
ARG GID=1000

RUN gem install bundler
RUN groupadd -g $GID -o $UNAME
RUN useradd -m -d /usr/src/app -u $UID -g $GID -o -s /bin/bash $UNAME
RUN mkdir -p /gems && chown $UID:$GID /gems
USER $UNAME
COPY --chown=$UID:$GID Gemfile* *gemspec /usr/src/app/
WORKDIR /usr/src/app
ENV BUNDLE_PATH /gems
ENV RUBYLIB /usr/src/app/lib
RUN bundle install
COPY --chown=$UID:$GID . /usr/src/app
