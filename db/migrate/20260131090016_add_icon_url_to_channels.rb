class AddIconUrlToChannels < ActiveRecord::Migration[7.2]
  def change
    add_column :channels, :icon_url, :string
  end
end
