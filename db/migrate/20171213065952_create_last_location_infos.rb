class CreateLastLocationInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :last_location_infos do |t|
      t.string :uid, null: false
      t.float :lat, null: false
      t.float :lon, null: false

      t.timestamps
    end

    add_index :last_location_infos, :uid, unique: true
  end
end
