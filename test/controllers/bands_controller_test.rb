require 'test_helper'

class BandsControllerTest < ActionController::TestCase
  test "should get my" do
    get :my
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get show" do
    get :show
    assert_response :success
  end

  test "should get destroy" do
    get :destroy
    assert_response :success
  end

end
