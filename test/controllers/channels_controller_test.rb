require "test_helper"

class ChannelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    log_in_as(@user)   # ← これが必要
  end

  test "should get index" do
    get channels_url
    assert_response :success
  end
end
