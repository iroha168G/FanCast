require 'rails_helper'

RSpec.describe "UserFavoriteChannels", type: :request do
  it "未ログインでアクセスするとリダイレクトされる" do
    post user_favorite_channels_path
    expect(response).to have_http_status(:redirect)
  end
end
