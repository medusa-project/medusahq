ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'rspec/expectations/minitest_integration'

class ActiveSupport::TestCase
  # Add more helper methods to be used by all tests here...
  include FactoryBot::Syntax::Methods

  def log_in
    @user = FactoryBot.create(:user)
    post '/auth/developer/callback', params: {name: @user.uid, email: @user.email}
  end

  def pending
    skip 'pending'
  end

end
