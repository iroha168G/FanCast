class ChangeChannelUniqueIndex < ActiveRecord::Migration[7.2]
  def change
    remove_index :channels, name: "index_channels_on_platform_and_channel_identifier"
    add_index :channels, [:user_id, :platform, :channel_identifier], unique: true
  end
end
