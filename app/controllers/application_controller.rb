class ApplicationController < ActionController::Base

  helper_method :current_user

  def current_user
    @current_user ||= User.find_by(id: session[:current_user_id])
  end

  def set_current_user(user)
    @current_user = user
    session[:current_user_id] = user.id
  end

  def unset_current_user
    @current_user = nil
    session[:current_user_id] = nil
  end

end
