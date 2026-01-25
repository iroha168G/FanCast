class AddUserToChannels < ActiveRecord::Migration[7.2]
  def change
    add_reference :channels, :user, null: false, foreign_key: true
  end
end
