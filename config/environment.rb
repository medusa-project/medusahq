# Load the Rails application.
require_relative 'application'

# Log to stdout except in production (where it still may go to stdout; see
# environments/production.rb)
Rails.logger = ActiveSupport::Logger.new(STDOUT) unless Rails.env.production?

# Initialize the Rails application.
Rails.application.initialize!
