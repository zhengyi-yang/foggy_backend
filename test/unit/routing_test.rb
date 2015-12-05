require 'test_helper'
require 'routing'

class RoutingTest < ActiveSupport::TestCase

  test 'should get route' do
    routing = Routing.instance
    result = routing.get_route(49.965,-5.215,49.961,-5.201)
    puts result
    assert_not_nil(result)
  end
end
