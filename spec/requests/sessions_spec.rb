require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  it "ログイン画面が表示される" do
    get login_path
    expect(response).to have_http_status(:ok)
  end
end
