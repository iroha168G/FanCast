class UserFavoriteChannel < ApplicationRecord
  belongs_to :user
  belongs_to :channel
end
