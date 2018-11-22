class CreateHouseExpenditureMargins < ActiveRecord::Migration[5.1]
  def change
    create_table :house_expenditure_margins do |t|
      t.belongs_to :house_expenditure, null: false, foreign_key: true
      t.integer :debtor, null: false
      t.integer :margin
      t.integer :fixed

      t.timestamps
    end
  end
end
