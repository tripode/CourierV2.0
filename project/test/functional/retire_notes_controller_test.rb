require 'test_helper'

class RetireNotesControllerTest < ActionController::TestCase
  setup do
    @retire_note = retire_notes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:retire_notes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create retire_note" do
    assert_difference('RetireNote.count') do
      post :create, retire_note: @retire_note.attributes
    end

    assert_redirected_to retire_note_path(assigns(:retire_note))
  end

  test "should show retire_note" do
    get :show, id: @retire_note
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @retire_note
    assert_response :success
  end

  test "should update retire_note" do
    put :update, id: @retire_note, retire_note: @retire_note.attributes
    assert_redirected_to retire_note_path(assigns(:retire_note))
  end

  test "should destroy retire_note" do
    assert_difference('RetireNote.count', -1) do
      delete :destroy, id: @retire_note
    end

    assert_redirected_to retire_notes_path
  end
end
