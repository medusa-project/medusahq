FROM ruby:2.6.3

ARG time_zone

#Set these two in ECS
#ENV RAILS_ENV=production
#ENV RAILS_CONFIGSET=aws_production

ENV RAILS_LOG_TO_STDOUT=true
ENV RAILS_MAX_THREADS=5
ENV RAILS_SERVE_STATIC_FILES=true
ENV TIME_ZONE=$time_zone

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get update && apt-get -y install nodejs

RUN mkdir /app
WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install --jobs 20 --retry 5

COPY . .

RUN bin/rails assets:precompile

EXPOSE 3000

CMD ["bundle", "exec", "bin/rails", "server"]