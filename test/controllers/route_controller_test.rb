require 'test_helper'

class RouteControllerTest < ActionController::TestCase
  test "should get route" do
    get :get_route, {lat_start: 49.965, long_start: -5.215, lat_end: 49.961, long_end: -5.201}
    assert_response :success

    result = JSON.parse(response.body)
    assert_not_nil result
  end

  test "should get unprocessable_entity with incomplete request" do
    get :get_route, {lat_start: 49.965, lat_end: 49.961, long_end: -5.201}
    assert_response :unprocessable_entity

    get :get_route, {long_start: -5.215, lat_end: 49.961, long_end: -5.201}
    assert_response :unprocessable_entity

    get :get_route, {lat_start: 49.965, long_start: -5.215, long_end: -5.201}
    assert_response :unprocessable_entity

    get :get_route, {lat_start: 49.965, long_start: -5.215, lat_end: 49.961}
    assert_response :unprocessable_entity

    get :get_route
    assert_response :unprocessable_entity
  end
end
