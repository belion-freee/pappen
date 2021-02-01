class AddUserIdLineUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :line_users, :user_id, :integer
  end
end
