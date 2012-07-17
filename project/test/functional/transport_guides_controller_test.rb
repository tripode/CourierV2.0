require 'test_helper'

class TransportGuidesControllerTest < ActionController::TestCase
  setup do
    @transport_guide = transport_guides(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:transport_guides)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create transport_guide" do
    assert_difference('TransportGuide.count') do
      post :create, transport_guide: @transport_guide.attributes
    end

    assert_redirected_to transport_guide_path(assigns(:transport_guide))
  end

  test "should show transport_guide" do
    get :show, id: @transport_guide
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @transport_guide
    assert_response :success
  end

  test "should update transport_guide" do
    put :update, id: @transport_guide, transport_guide: @transport_guide.attributes
    assert_redirected_to transport_guide_path(assigns(:transport_guide))
  end

  test "should destroy transport_guide" do
    assert_difference('TransportGuide.count', -1) do
      delete :destroy, id: @transport_guide
    end

    assert_redirected_to transport_guides_path
  end
end
