class User < ApplicationRecord
  attr_accessor :reset_token

  # パスワード暗号化
  has_secure_password

  # 名前: 必須・50文字以内
  validates :name, presence: true, length: { maximum: 50 }

  # メール: 必須・255文字以内・フォーマット・一意
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email,
            presence: true,
            length: { maximum: 255 },
            format: { with: VALID_EMAIL_REGEX },
            uniqueness: { case_sensitive: false }

  # パスワード: 必須・4文字以上
  validates :password, presence: true, length: { minimum: 4 }, allow_nil: true

  # 保存前にメールを小文字化
  before_save { self.email = email.downcase }

  # ==============================
  # パスワードリセット関連
  # ==============================

  # ランダムなトークンを生成
  def self.new_token
    SecureRandom.urlsafe_base64
  end

  # 文字列のハッシュ値を返す
  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # リセット用トークンを生成して digest を DB に保存
  def create_reset_digest
    self.reset_token = User.new_token
    update!(
      reset_digest: User.digest(reset_token),
      reset_sent_at: Time.zone.now
    )
  end

  # トークンが digest と一致するか
  def authenticated?(token)
    return false if reset_digest.nil?
    BCrypt::Password.new(reset_digest).is_password?(token)
  end

  # リセットトークンの有効期限チェック（2時間）
  def reset_token_valid?
    reset_sent_at.present? && reset_sent_at > 2.hours.ago
  end

  # パスワード更新と reset_digest の破棄
  def reset_password!(new_password)
    update!(password: new_password, reset_digest: nil)
  end

  # パスワードリセットメール送信
  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  has_many :user_favorite_channels, dependent: :destroy
  has_many :favorite_channels,
           through: :user_favorite_channels,
           source: :channel
end
