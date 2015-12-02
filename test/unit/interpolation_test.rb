require 'test_helper'
require 'datainterp'

class InterpolationTest < ActiveSupport::TestCase

  test 'getData' do  
    datainterp = DataInterp.instance
    result = datainterp.calc([51.588918], [-0.059104], true)
    puts result
  end
end