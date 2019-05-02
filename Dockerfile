FROM ruby:2.6.3

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - && apt-get update && apt-get -y install nodejs

WORKDIR /app

COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

COPY . .

CMD ["bundle", "exec", "rails", "server"]