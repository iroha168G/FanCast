class Channel < ApplicationRecord
  enum platform: {
    youtube: 0
  }

  has_many :user_favorite_channels, dependent: :destroy
  has_many :users, through: :user_favorite_channels

  validates :platform, :name, :channel_identifier, :thumbnail_url, presence: true
end
