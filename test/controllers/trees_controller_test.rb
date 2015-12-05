require 'test_helper'

class TreesControllerTest < ActionController::TestCase
  def setup
    @user = users(:one)
  end

  test "should get all trees" do
    @request.headers['Authorization'] = 'Token token='+@user.authentication_token
    get :index
    result = JSON.parse(response.body)
    assert_equal(2, result.size)
    assert_response :success
    assert_equal(trees(:one).name, result[0]['name'])
    assert_equal(trees(:two).name, result[1]['name'])
  end

  test "should get tree by id" do
    @request.headers['Authorization'] = 'Token token='+@user.authentication_token
    get :show, {id: 111}
    result = JSON.parse(response.body)
    assert_response :success
    assert_equal(trees(:one).name, result['name'])
  end

  test "should create tree" do
    @request.headers['Authorization'] = 'Token token='+@user.authentication_token
    assert_difference('Tree.count') do
      post :create, tree: {name: 'newTree', user_id: @user.id}
    end
    assert_response :success
  end

  test "should not create tree without name" do
    @request.headers['Authorization'] = 'Token token='+@user.authentication_token
    post :create, tree: {user_id: @user.id}
    assert_response :unprocessable_entity
  end

  test "should update tree" do
    @request.headers['Authorization'] = 'Token token='+@user.authentication_token
    new_name = 'NewName'
    put :update, id: 111, tree:{name: new_name}
    assert_response :no_content
    assert_equal(new_name, Tree.find(111).name)
  end

  test "should destroy tree" do
    assert_difference('Tree.count', -1) do
      @request.headers['Authorization'] = 'Token token='+@user.authentication_token
      delete :destroy, {id: 111}
    end
    assert_response 204
  end

  test "should get 401 unauthorized without token" do
    get :show, {id: 111}
    assert_response :unauthorized
    get :index
    assert_response :unauthorized
    post :create
    assert_response :unauthorized
    put :update, {id: 111}
    assert_response :unauthorized
    delete :destroy, {id: 111}
    assert_response :unauthorized
  end
end
