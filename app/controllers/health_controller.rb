class HealthController < ApplicationController

  skip_before_action :require_logged_in

  def show
    @time = Time.now
  end

end