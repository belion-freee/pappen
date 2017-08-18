class CreateInterChanges < ActiveRecord::Migration[5.1]
  def change
    create_table :inter_changes do |t|
      t.string :prefectures
      t.string :highway
      t.string :ic

      t.timestamps
    end
  end
end
