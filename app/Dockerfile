FROM ruby:3.0.2

ENV APP_ROOT /var/lib/app
WORKDIR $APP_ROOT

ENV LANG C.UTF-8
ENV LANGUAGE=en_US:
ENV PS1 "\[\e[31m\][\[\e[m\]\[\e[38;5;172m\]\u\[\e[m\]@\[\e[38;5;153m\]\h\[\e[m\] \[\e[38;5;214m\]\w\[\e[m\]\[\e[31m\]]\[\e[m\]\\$ "
ENV RAILS_ROOT $APP_ROOT
ENV RAILS_ENV production
ENV RACK_ENV production
ENV NODE_ENV production

RUN apt-get update -qq && \
    apt-get install -y --no-install-recommends \
    default-mysql-client \
    build-essential \
    nodejs \
    npm && \
    npm install -g n yarn && \
    n 14.17.6 && \
    apt-get --purge remove -y npm && \
    rm -rf /var/lib/apt/lists/* && \
    groupadd -g 999 rails && \
    useradd -m -r -u 999 -g rails rails

COPY Gemfile Gemfile.lock ./
# COPY engines $APP_ROOT/engines
RUN bundle install -j "$(getconf _NPROCESSORS_ONLN)" --retry 5 --without development test

COPY package.json yarn.lock ./
RUN yarn install --production=true && yarn cache clean

COPY --chown=rails:rails . .

RUN mkdir -p tmp/pids && chown -R rails:rails tmp/pids
RUN mkdir -p log && chown -R rails:rails log

USER rails

RUN bundle exec rake assets:precompile

CMD bundle exec rake db:migrate && bundle exec puma
