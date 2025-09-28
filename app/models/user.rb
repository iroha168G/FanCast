class User < ApplicationRecord
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

  # パスワード: 必須・8文字以上
  validates :password, presence: true, length: { minimum: 4 }

  # 保存前にメールを小文字化
  before_save { self.email = email.downcase }
end
