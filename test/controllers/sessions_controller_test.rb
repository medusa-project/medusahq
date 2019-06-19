require 'test_helper'

class SessionsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @user = FactoryBot.create(:user)
  end

  test 'user log in' do
    post '/auth/developer/callback', params: {name: @user.uid, email: @user.email}
    assert_redirected_to root_url
    assert session[:current_user_id]
  end

  test 'user log in with bad information goes back to login page' do
    post '/auth/developer/callback', params: {}
    assert_redirected_to login_url
  end

  test 'user log out' do
    log_in
    assert session[:current_user_id]
    get logout_path
    assert_redirected_to root_url
    refute session[:current_user_id]
  end

  test 'going to login path redirects to shibboleth auth path' do
    get login_path
    assert_redirected_to '/auth/developer'
  end

end