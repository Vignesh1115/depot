require 'test_helper'

class SessionsControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should login" do
    yoda = users(:one)
    post :create, name: yoda.name, password: 'yoda'
    assert_redirected_to admin_url
    assert_equal yoda.id, session[:user_id]
  end

  test "should fail login" do
    yoda = users(:one)
    post :create, name: :yoda, password: 'vader'
    assert_redirected_to login_url
  end

  test "should logout" do
    delete :destroy
    assert_redirected_to store_url
  end
end
