class AddActivatedToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :activated, :boolean
  end
end
