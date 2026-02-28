class User < ApplicationRecord
  attr_accessor :reset_token

  # ==============================
  # 認証
  # ==============================
  has_secure_password

  # ==============================
  # バリデーション
  # ==============================
  validates :name, presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
            presence: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  # allow_nil: true は「更新時のみ省略可」という意味
  validates :password, presence: true, length: { minimum: 4 }, allow_nil: true

  # ==============================
  # コールバック
  # ==============================
  before_save :downcase_email

  def downcase_email
    self.email = email.downcase
  end

  # ==============================
  # mock 用
  # ==============================
  def mock?
    mock_user
  end

  def favorite_channels_for_view
    if mock?
      Youtube::Mock::FavoriteChannels.new.all
    else
      favorite_channels
    end
  end

  # ==============================
  # パスワードリセット
  # ==============================

  # ランダムトークン生成
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # トークンを digest 化
  def self.digest(string)
    cost =
      if ActiveModel::SecurePassword.min_cost
        BCrypt::Engine::MIN_COST
      else
        BCrypt::Engine.cost
      end

    BCrypt::Password.create(string, cost: cost)
  end

  # reset_token を作って DB に保存
  def create_reset_digest
    self.reset_token = User.new_token
    update!(
      reset_digest: User.digest(reset_token),
      reset_sent_at: Time.current
    )
  end

  # トークン照合
  def authenticated?(token)
    return false if reset_digest.blank? || token.blank?
    BCrypt::Password.new(reset_digest).is_password?(token)
  end
  # トークン期限（2時間）
  def reset_token_valid?
    reset_sent_at.present? && reset_sent_at > 2.hours.ago
  end

  # パスワード更新 + トークン破棄
  def reset_password!(new_password)
    update!(
      password: new_password,
      reset_digest: nil,
      reset_sent_at: nil
    )
  end

  # メール送信
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  # ==============================
  # Association
  # ==============================
  has_many :user_favorite_channels, dependent: :destroy
  has_many :favorite_channels,
           through: :user_favorite_channels,
           source: :channel
end
