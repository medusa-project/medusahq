class ApplicationController < ActionController::Base

  helper_method :current_user
  before_action :require_logged_in

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

  def require_logged_in
    redirect_non_logged_in_user unless logged_in?
  end

  def logged_in?
    current_user.present?
  end

  def redirect_non_logged_in_user
    session[:login_return_uri] = request.env['REQUEST_URO']
    redirect_to(login_path)
  end

end
