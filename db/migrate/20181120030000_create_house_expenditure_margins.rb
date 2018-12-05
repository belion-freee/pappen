class CreateHouseExpenditureMargins < ActiveRecord::Migration[5.1]
  def change
    create_table :house_expenditure_margins do |t|
      t.belongs_to :house_expenditure, null: false, foreign_key: true
      t.belongs_to :room_member, null: false, foreign_key: true
      t.integer :margin
      t.integer :fixed

      t.timestamps
    end
  end
end
