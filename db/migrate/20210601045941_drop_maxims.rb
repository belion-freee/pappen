class DropMaxims < ActiveRecord::Migration[5.1]
  def up
    drop_table :maxims
    drop_table :last_maxim_infos
  end

  def down
    
  end
end
