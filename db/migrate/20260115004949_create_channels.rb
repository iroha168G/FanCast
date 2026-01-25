class CreateChannels < ActiveRecord::Migration[7.2]
  def change
    create_table :channels do |t|
      t.integer :platform, null: false
      t.string :name, null: false
      t.string :channel_identifier, null: false
      t.string :thumbnail_url, null: false
      t.timestamps
    end

    add_index :channels, [:platform, :channel_identifier], unique: true
  end
end
