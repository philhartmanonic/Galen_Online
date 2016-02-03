require 'test_helper'

class BandsControllerTest < ActionController::TestCase
  setup do
    @band = bands(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:bands)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create band" do
    assert_difference('Band.count') do
      post :create, band: { fb_id: @band.fb_id, fb_name: @band.fb_name, follower_count: @band.follower_count, following_count: @band.following_count, likes_count: @band.likes_count, name: @band.name, pic_url: @band.pic_url, ta_count: @band.ta_count, tweets: @band.tweets }
    end

    assert_redirected_to band_path(assigns(:band))
  end

  test "should show band" do
    get :show, id: @band
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @band
    assert_response :success
  end

  test "should update band" do
    patch :update, id: @band, band: { fb_id: @band.fb_id, fb_name: @band.fb_name, follower_count: @band.follower_count, following_count: @band.following_count, likes_count: @band.likes_count, name: @band.name, pic_url: @band.pic_url, ta_count: @band.ta_count, tweets: @band.tweets }
    assert_redirected_to band_path(assigns(:band))
  end

  test "should destroy band" do
    assert_difference('Band.count', -1) do
      delete :destroy, id: @band
    end

    assert_redirected_to bands_path
  end
end
