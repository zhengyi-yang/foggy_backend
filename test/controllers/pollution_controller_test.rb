require 'test_helper'

class PollutionControllerTest < ActionController::TestCase
  test "should get pollution data" do
    get :get_pollution, {lat: 0, long: 0}
    assert_response :success

    result = JSON.parse(response.body)
    assert_not_nil result['index']
  end

  test "should get unprocessable_entity with incomplete request" do
    get :get_pollution, {long: 0}
    assert_response :unprocessable_entity

    get :get_pollution, {lat: 0}
    assert_response :unprocessable_entity

    get :get_pollution
    assert_response :unprocessable_entity
  end
end
