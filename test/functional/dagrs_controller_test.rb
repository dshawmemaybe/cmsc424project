require 'test_helper'

class DagrsControllerTest < ActionController::TestCase
  setup do
    @dagr = dagrs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:dagrs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create dagr" do
    assert_difference('Dagr.count') do
      post :create, dagr: {  }
    end

    assert_redirected_to dagr_path(assigns(:dagr))
  end

  test "should show dagr" do
    get :show, id: @dagr
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @dagr
    assert_response :success
  end

  test "should update dagr" do
    put :update, id: @dagr, dagr: {  }
    assert_redirected_to dagr_path(assigns(:dagr))
  end

  test "should destroy dagr" do
    assert_difference('Dagr.count', -1) do
      delete :destroy, id: @dagr
    end

    assert_redirected_to dagrs_path
  end
end
