class FixChannelUniqueIndex < ActiveRecord::Migration[7.1]
  def change
    remove_index :channels,
                 name: "index_channels_on_user_id_and_platform_and_channel_identifier",
                 if_exists: true

    add_index :channels, [:platform, :channel_identifier], unique: true
  end
end
