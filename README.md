# Medusa Collection Manager

## Development Setup

```
# Install RVM
$ \curl -sSL https://get.rvm.io | bash -s stable
$ source ~/.bash_profile

# Clone the repository
$ git clone https://github.com/medusa-project/collection-manager.git
$ cd collection-manager

# Install Ruby
$ rvm install "$(< .ruby-version)" --autolibs=0

# Install Bundler
$ gem install bundler

# Install gems
$ bundle install

# Configure the application
$ cp config/application.yml.template config/application.yml
# (Edit application.yml as necessary)

# Create and seed the database
$ bin/rails db:create
$ bin/rails db:seed

# Import collections from Medusa
$ bin/rails medusa:import
```
