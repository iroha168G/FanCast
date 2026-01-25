class CreateUserFavoriteChannels < ActiveRecord::Migration[7.2]
  def change
    create_table :user_favorite_channels do |t|
      t.references :user, null: false, foreign_key: true
      t.references :channel, null: false, foreign_key: true

      t.timestamps
    end
  end
end
