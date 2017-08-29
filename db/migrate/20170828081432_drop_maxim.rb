class DropMaxim < ActiveRecord::Migration[5.1]
  def change
    drop_table :maxims
  end
end
