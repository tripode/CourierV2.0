require 'test_helper'

class CargoManifestsControllerTest < ActionController::TestCase
  setup do
    @cargo_manifest = cargo_manifests(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:cargo_manifests)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create cargo_manifest" do
    assert_difference('CargoManifest.count') do
      post :create, cargo_manifest: @cargo_manifest.attributes
    end

    assert_redirected_to cargo_manifest_path(assigns(:cargo_manifest))
  end

  test "should show cargo_manifest" do
    get :show, id: @cargo_manifest
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @cargo_manifest
    assert_response :success
  end

  test "should update cargo_manifest" do
    put :update, id: @cargo_manifest, cargo_manifest: @cargo_manifest.attributes
    assert_redirected_to cargo_manifest_path(assigns(:cargo_manifest))
  end

  test "should destroy cargo_manifest" do
    assert_difference('CargoManifest.count', -1) do
      delete :destroy, id: @cargo_manifest
    end

    assert_redirected_to cargo_manifests_path
  end
end
