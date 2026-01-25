class AddUniqueIndexToUserFavoriteChannels < ActiveRecord::Migration[7.2]
  def change
    add_index :user_favorite_channels,
              [:user_id, :channel_id],
              unique: true
  end
end
