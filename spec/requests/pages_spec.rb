require 'rails_helper'

RSpec.describe "Pages", type: :request do
  it "利用規約ページが表示される" do
    get "/terms"
    expect(response).to have_http_status(:ok)
  end

  it "プライバシーポリシーが表示される" do
    get "/privacy"
    expect(response).to have_http_status(:ok)
  end
end
