require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  def setup
    @user = users(:one)
  end

  test "should create user" do
    assert_difference('User.count') do
      post :create, user: {username: 'tester1', password: 'encrypted', email: 'tester1@test.com'}
    end
    assert_response :success
    result = JSON.parse(response.body)
    assert_not_nil result['authentication_token']
  end

  test "should encrypt password" do
    password = 'encrypted'
    post :create, user: {username: 'tester1', password: password, email: 'tester1@test.com'}
    user = User.find_by(email: 'tester1@test.com')
    assert_not_equal(password, user.password_digest)
  end

  test "should not create user without password" do
    post :create, user: {username: 'tester1', email: 'tester1@test.com'}
    assert_response :unprocessable_entity
  end

  test "should not create user without email" do
    post :create, user: {username: 'tester1', password: 'encrypted'}
    assert_response :unprocessable_entity
  end

  test "should not create user without username" do
    post :create, user: {password: 'encrypted', email: 'tester1@test.com'}
    assert_response :unprocessable_entity
  end

  test "should get user by token" do
    @request.headers['Authorization'] = 'Token token='+@user.authentication_token
    post :show
    result = JSON.parse(response.body)
    assert_equal(@user.email, result['email'])
  end

  test "should get 401 unauthorized without token" do
    puts @request.headers['Authorization']
    post :show
    assert_response :unauthorized
  end

  test "should update user with token" do
    @request.headers['Authorization'] = 'Token token='+@user.authentication_token
    new_name = 'NewName'
    put :update, user: {username: new_name}
    assert_response :no_content
    assert_equal(new_name, User.find_by(authentication_token: @user.authentication_token).username)
  end

  test "should destroy user" do
    assert_difference('User.count', -1) do
      @request.headers['Authorization'] = 'Token token='+@user.authentication_token
      delete :destroy
    end
    assert_response 204
  end
end
