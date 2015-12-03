require 'test_helper'
require 'datainterp'

class InterpolationTest < ActiveSupport::TestCase

  test 'getDataOffRange' do
    datainterp = DataInterp.instance
    result = datainterp.calc(0, 0)
    # puts result
    assert_equal(0, result)
  end

  test 'getDataArrayOffRange' do
    datainterp = DataInterp.instance
    result = datainterp.calc([0], [0])
    # puts result
    assert_equal([0], result)
  end

  test 'getData' do
    datainterp = DataInterp.instance
    result = datainterp.calc(0.18487713, 51.46598327)
    # puts result
    assert_equal(3, result)
  end

  test 'getDataArray' do
    datainterp = DataInterp.instance
    result = datainterp.calc([0.18487713,0.1328125], [51.46598327,51.53125])
    # puts result
    assert_equal([3,2], result)
  end
end
