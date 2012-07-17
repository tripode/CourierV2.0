require 'test_helper'

class ReceiverAddressesControllerTest < ActionController::TestCase
  setup do
    @receiver_address = receiver_addresses(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:receiver_addresses)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create receiver_address" do
    assert_difference('ReceiverAddress.count') do
      post :create, receiver_address: @receiver_address.attributes
    end

    assert_redirected_to receiver_address_path(assigns(:receiver_address))
  end

  test "should show receiver_address" do
    get :show, id: @receiver_address
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @receiver_address
    assert_response :success
  end

  test "should update receiver_address" do
    put :update, id: @receiver_address, receiver_address: @receiver_address.attributes
    assert_redirected_to receiver_address_path(assigns(:receiver_address))
  end

  test "should destroy receiver_address" do
    assert_difference('ReceiverAddress.count', -1) do
      delete :destroy, id: @receiver_address
    end

    assert_redirected_to receiver_addresses_path
  end
end
