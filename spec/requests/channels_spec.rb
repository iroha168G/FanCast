require 'rails_helper'

RSpec.describe "Channels", type: :request do
  describe "ログインしてる場合にのみアクセスできる" do
    let(:user) { create(:user) }

    before do
      post login_path, params: {
        email: user.email,
        password: user.password
      }
    end

    it "一覧ページが表示される" do
      get channels_path
      expect(response).to have_http_status(:ok)
    end

    it "検索ページが表示される" do
      get channels_search_path
      expect(response).to have_http_status(:ok)
    end
  end

  describe "ログインしてない場合はアクセスできない" do
    it "一覧ページが表示されずにログイン画面にリダイレクト" do
      get channels_path
      expect(response).to redirect_to(login_path)
    end

    it "検索ページが表示されずにログイン画面にリダイレクト" do
      get channels_search_path
      expect(response).to redirect_to(login_path)
    end
  end
end
