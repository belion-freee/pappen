class CreateHouseExpenditures < ActiveRecord::Migration[5.1]
  def change
    create_table :house_expenditures do |t|
      t.string :house_id, null: false
      t.belongs_to :room_member, null: false, foreign_key: true
      t.date :entry_date, null: false
      t.string :category, null: false
      t.integer :payment, null: false
      t.string :name

      t.timestamps
    end
    add_foreign_key :house_expenditures, :houses, column: :house_id, primary_key: :hid
    add_index  :house_expenditures, :house_id
  end
end
