require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test 'user validations' do
    @subject = User.new
    must validate_presence_of(:uid)
    must validate_presence_of(:email)
  end

end