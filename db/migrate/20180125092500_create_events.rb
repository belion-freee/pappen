class CreateEvents < ActiveRecord::Migration[5.1]
  def change
    create_table :events do |t|
      t.string :name, null: false
      t.string :place
      t.datetime :start
      t.datetime :end
      t.text :memo

      t.timestamps
    end
  end
end
