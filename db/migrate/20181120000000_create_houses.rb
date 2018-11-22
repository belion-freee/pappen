class CreateHouses < ActiveRecord::Migration[5.1]
  def change
    create_table :houses do |t|
      t.string :name, null: false
      t.text :memo

      t.timestamps
    end
  end
end
