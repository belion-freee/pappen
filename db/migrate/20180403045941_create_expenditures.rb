class CreateExpenditures < ActiveRecord::Migration[5.1]
  def change
    create_table :expenditures do |t|
      t.string  :line_user_id, null: false
      t.date    :entry_date,   null: false
      t.string  :category,     null: false
      t.integer :payment,      null: false
      t.text    :memo

      t.timestamps
    end
  end
end
