require 'test_helper'

class RountingSheetsControllerTest < ActionController::TestCase
  setup do
    @rounting_sheet = rounting_sheets(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rounting_sheets)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rounting_sheet" do
    assert_difference('RountingSheet.count') do
      post :create, rounting_sheet: @rounting_sheet.attributes
    end

    assert_redirected_to rounting_sheet_path(assigns(:rounting_sheet))
  end

  test "should show rounting_sheet" do
    get :show, id: @rounting_sheet
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rounting_sheet
    assert_response :success
  end

  test "should update rounting_sheet" do
    put :update, id: @rounting_sheet, rounting_sheet: @rounting_sheet.attributes
    assert_redirected_to rounting_sheet_path(assigns(:rounting_sheet))
  end

  test "should destroy rounting_sheet" do
    assert_difference('RountingSheet.count', -1) do
      delete :destroy, id: @rounting_sheet
    end

    assert_redirected_to rounting_sheets_path
  end
end
