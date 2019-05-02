FROM ruby:2.6.3

ARG time_zone

ENV RAILS_ENV=production
#ENV RAILS_CONFIGSET=aws_production

ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_MAX_THREADS=5
ENV RAILS_SERVE_STATIC_FILES=true
ENV TIME_ZONE=$time_zone

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" > /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get -y install nodejs yarn

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --without development test --jobs 20 --retry 5

COPY . .

RUN bin/rails assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "bin/rails", "server"]