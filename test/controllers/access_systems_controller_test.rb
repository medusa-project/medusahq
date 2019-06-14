require 'test_helper'

class AccessSystemsControllerTest < ActionDispatch::IntegrationTest

  test 'access systems index' do
    log_in
    get access_systems_path
    assert_response :success
  end

end