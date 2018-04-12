class CreateLineUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :line_users do |t|
      t.string :code, null: false
      t.string :uid,  null: false
      t.string :name, null: false

      t.timestamps
    end
    # add_index :line_users, :id, unique: true
  end
end
