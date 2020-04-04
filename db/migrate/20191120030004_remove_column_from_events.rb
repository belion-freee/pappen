class RemoveColumnFromEvents < ActiveRecord::Migration[5.1]
  def up
    remove_column :events, :place
    remove_column :events, :start
    remove_column :events, :end
  end

  def down
    add_column :events, :place, :string
    add_column :events, :start, :datetime
    add_column :events, :end, :datetime
  end
end
