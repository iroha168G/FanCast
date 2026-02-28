ENV["RAILS_ENV"] ||= "test"
require_relative "../config/environment"
require "rails/test_help"

module ActiveSupport
  class TestCase
    # 並列テスト
    parallelize(workers: :number_of_processors)

    # fixtures を全テストで有効化
    fixtures :all
  end
end

# ==============================
# IntegrationTest 用ヘルパー
# ==============================
class ActionDispatch::IntegrationTest
  # ログイン状態を作る
  def log_in_as(user, password: "password")
    post login_url, params: {
      email: user.email,
      password: password
    }
  end
end
