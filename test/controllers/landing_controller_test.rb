require 'test_helper'

class LandingControllerTest < ActionDispatch::IntegrationTest

  test 'there is a landing page' do
    log_in
    get root_path
    assert_response :success
  end

end
