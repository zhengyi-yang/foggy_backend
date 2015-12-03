require 'test_helper'
require 'datainterp'

class InterpolationTest < ActiveSupport::TestCase

  test 'getData' do
    datainterp = DataInterp.instance
    result = datainterp.calc([51.552476], [-0.258089], true)
    # puts result
    assert_equal(2, result[0])
  end
end
