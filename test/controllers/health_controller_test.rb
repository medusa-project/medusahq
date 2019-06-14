require 'test_helper'

class HealthControllerTest < ActionDispatch::IntegrationTest

  test 'public can get health check, which just shows the time' do
    freeze_time do
      get health_path
      assert_response :success
      assert_select 'p', "Medusa HQ is up at #{Time.now}"
    end
  end

end