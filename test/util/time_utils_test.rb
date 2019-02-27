require 'test_helper'

class TimeUtilsTest < ActiveSupport::TestCase

  # eta()

  test 'eta works' do
    expected = 1.year.from_now
    actual = TimeUtil.eta(5.hours.ago, 0.0)
    assert actual - expected < 1

    expected = 5.hours.from_now
    actual = TimeUtil.eta(5.hours.ago, 0.5)
    assert actual - expected < 1

    expected = 6.hours.from_now
    actual = TimeUtil.eta(2.hours.ago, 0.25)
    assert actual - expected < 1

    expected = 2.hours.from_now
    actual = TimeUtil.eta(6.hours.ago, 0.75)
    assert actual - expected < 1

    expected = Time.now.utc
    actual = TimeUtil.eta(6.hours.ago, 1.0)
    assert actual - expected < 1
  end

end
