require 'test_helper'

class RoutingSheetDetailsControllerTest < ActionController::TestCase
  setup do
    @routing_sheet_detail = routing_sheet_details(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:routing_sheet_details)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create routing_sheet_detail" do
    assert_difference('RoutingSheetDetail.count') do
      post :create, routing_sheet_detail: @routing_sheet_detail.attributes
    end

    assert_redirected_to routing_sheet_detail_path(assigns(:routing_sheet_detail))
  end

  test "should show routing_sheet_detail" do
    get :show, id: @routing_sheet_detail
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @routing_sheet_detail
    assert_response :success
  end

  test "should update routing_sheet_detail" do
    put :update, id: @routing_sheet_detail, routing_sheet_detail: @routing_sheet_detail.attributes
    assert_redirected_to routing_sheet_detail_path(assigns(:routing_sheet_detail))
  end

  test "should destroy routing_sheet_detail" do
    assert_difference('RoutingSheetDetail.count', -1) do
      delete :destroy, id: @routing_sheet_detail
    end

    assert_redirected_to routing_sheet_details_path
  end
end
