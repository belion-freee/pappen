class CreateHouseBills < ActiveRecord::Migration[5.1]
  def change
    create_table :house_bills do |t|
      t.string :house_id, null: false
      t.date :entry_date, null: false
      t.boolean :done, default: false, null: false
      t.integer :user_id

      t.timestamps
    end
    add_foreign_key :house_bills, :houses, column: :house_id, primary_key: :hid
    add_index  :house_bills, :house_id
  end
end
