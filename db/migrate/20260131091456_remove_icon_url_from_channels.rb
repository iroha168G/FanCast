class RemoveIconUrlFromChannels < ActiveRecord::Migration[7.2]
  def change
    remove_column :channels, :icon_url, :string
  end
end
