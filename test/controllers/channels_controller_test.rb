require "test_helper"

class ChannelsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    log_in_as(@user)
  end

  test "should get index" do
    get channels_url
    assert_response :success
  end

  test "should create channel" do
    post channels_url, params: {
      channel: { channel_id: "abc123" }
    }
    assert_response :redirect
  end
end
