class CreateLastMaximInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :last_maxim_infos do |t|
      t.integer :maxim_id

      t.timestamps
    end
  end
end
