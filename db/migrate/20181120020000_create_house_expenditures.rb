class CreateHouseExpenditures < ActiveRecord::Migration[5.1]
  def change
    create_table :house_expenditures do |t|
      t.belongs_to :house, null: false, foreign_key: true
      t.belongs_to :room_member, null: false, foreign_key: true
      t.date :entry_date, null: false
      t.string :category, null: false
      t.integer :payment, null: false
      t.string :name

      t.timestamps
    end
  end
end
