class RemoveColumnFromEvents < ActiveRecord::Migration[5.1]
  def up
    remove_column :events, :place
    remove_column :events, :start
    remove_column :events, :end
  end

  def down
    t.string :place
    t.datetime :start
    t.datetime :end
  end
end
