require 'test_helper'

class StatesControllerTest < ActionController::TestCase
  setup do
    @state = states(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:states)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create state" do
    assert_difference('State.count') do
      post :create, state: { dem_date: @state.dem_date, dem_pledged: @state.dem_pledged, dem_unpledged: @state.dem_unpledged, gop_date: @state.gop_date, gop_pledged: @state.gop_pledged, gop_unpledged: @state.gop_unpledged, name: @state.name, p_or_c: @state.p_or_c }
    end

    assert_redirected_to state_path(assigns(:state))
  end

  test "should show state" do
    get :show, id: @state
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @state
    assert_response :success
  end

  test "should update state" do
    patch :update, id: @state, state: { dem_date: @state.dem_date, dem_pledged: @state.dem_pledged, dem_unpledged: @state.dem_unpledged, gop_date: @state.gop_date, gop_pledged: @state.gop_pledged, gop_unpledged: @state.gop_unpledged, name: @state.name, p_or_c: @state.p_or_c }
    assert_redirected_to state_path(assigns(:state))
  end

  test "should destroy state" do
    assert_difference('State.count', -1) do
      delete :destroy, id: @state
    end

    assert_redirected_to states_path
  end

  test "should return @dem_winners values" do
    get :calendar
    assert_not_nil @dem_winners["58"]
  end

  test "should return values for all states" do
    get :calendar
    @calendar_states.each do |k, v|
      assert_not_nil @calendar_states[k]
    end
  end
end
