require 'test_helper'

class PollutionControllerTest < ActionController::TestCase
  test "should get pollution data" do
    get :get_pollution, {lat: 0, long: 0}
    assert_response :success

    result = JSON.parse(response.body)
    assert_not_nil result['index']
  end

  test "should get 400 with incomplete request" do
    get :get_pollution, {long: 0}
    assert_response :bad_request

    get :get_pollution, {lat: 0}
    assert_response :bad_request

    get :get_pollution
    assert_response :bad_request
  end
end
