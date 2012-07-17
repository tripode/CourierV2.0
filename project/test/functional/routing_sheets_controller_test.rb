require 'test_helper'

class RoutingSheetsControllerTest < ActionController::TestCase
  setup do
    @routing_sheet = routing_sheets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:routing_sheets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create routing_sheet" do
    assert_difference('RoutingSheet.count') do
      post :create, routing_sheet: @routing_sheet.attributes
    end

    assert_redirected_to routing_sheet_path(assigns(:routing_sheet))
  end

  test "should show routing_sheet" do
    get :show, id: @routing_sheet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @routing_sheet
    assert_response :success
  end

  test "should update routing_sheet" do
    put :update, id: @routing_sheet, routing_sheet: @routing_sheet.attributes
    assert_redirected_to routing_sheet_path(assigns(:routing_sheet))
  end

  test "should destroy routing_sheet" do
    assert_difference('RoutingSheet.count', -1) do
      delete :destroy, id: @routing_sheet
    end

    assert_redirected_to routing_sheets_path
  end
end
