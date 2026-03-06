require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  it "パスワード再設定画面が表示される" do
    get new_password_reset_path
    expect(response).to have_http_status(:ok)
  end
end
