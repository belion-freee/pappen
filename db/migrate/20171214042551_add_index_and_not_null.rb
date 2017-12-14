class AddIndexAndNotNull < ActiveRecord::Migration[5.1]
  def change
    # add index and unique to uid
    add_index :last_dialogue_infos, :uid, unique: true

    # add not null
    change_column_null :last_dialogue_infos, :uid, false
    change_column_null :last_dialogue_infos, :mode, false
    change_column_null :last_dialogue_infos, :context, false
  end
end
