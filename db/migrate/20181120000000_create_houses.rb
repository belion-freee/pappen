class CreateHouses < ActiveRecord::Migration[5.1]
  def change
    create_table :houses, id: false do |t|
      t.string :hid,  null: false
      t.string :name, null: false
      t.text :memo

      t.timestamps
    end

    reversible do |r|
      r.up { execute "ALTER TABLE houses ADD PRIMARY KEY (hid);" }
    end
  end
end
