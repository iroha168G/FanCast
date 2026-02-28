require "test_helper"

class PasswordResetsControllerTest < ActionDispatch::IntegrationTest
  test "should get edit with valid token" do
    user = users(:one)
    user.create_reset_digest

    get edit_password_reset_url(user.id, token: user.reset_token)
    assert_response :success
  end

  test "should redirect with invalid token" do
    user = users(:one)
    user.create_reset_digest

    get edit_password_reset_url(user.id, token: "invalid")
    assert_redirected_to root_url
  end
end
