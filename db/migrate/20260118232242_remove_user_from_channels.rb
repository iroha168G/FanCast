class RemoveUserFromChannels < ActiveRecord::Migration[7.2]
  def change
    remove_reference :channels, :user, foreign_key: true
  end
end
