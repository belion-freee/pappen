class CreateExpenses < ActiveRecord::Migration[5.1]
  def change
    create_table :expenses do |t|
      t.string :name
      t.integer :event_id
      t.integer :room_member_id
      t.integer :payment
      t.text :memo

      t.timestamps
    end
  end
end
