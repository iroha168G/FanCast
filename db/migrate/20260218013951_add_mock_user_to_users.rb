class AddMockUserToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :mock_user, :boolean, default: false, null: false
  end
end
