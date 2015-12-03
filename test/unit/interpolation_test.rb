require 'test_helper'
require 'datainterp'

class InterpolationTest < ActiveSupport::TestCase

  test 'getData' do
    datainterp = DataInterp.instance
    result = datainterp.calc([51.529389], [0.132857], true)
    # puts result
    assert_equal(2, result[0])
  end
end
