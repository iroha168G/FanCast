require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get signup_url
    assert_response :success
  end

  test "should create user" do
    email = "test_#{SecureRandom.uuid}@example.com"

    assert_difference("User.count", 1) do
      post users_url, params: {
        user: {
          name: "Test",
          email: email,
          password: "password",
          password_confirmation: "password"
        }
      }
    end

    assert_redirected_to root_url
  end
end
