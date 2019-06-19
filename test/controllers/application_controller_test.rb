require 'test_helper'

class ApplicationControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = FactoryBot.create(:user)
  end

  test 'user not logged in is redirected on accessing protected page' do
    get repositories_path
    assert_redirected_to login_path
    assert session[:login_return_uri] = login_path
  end

end