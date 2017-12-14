class CreateLastDialogueInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :last_dialogue_infos do |t|
      t.string :uid, null: false
      t.string :mode, null: false
      t.string :context, null: false

      t.timestamps
    end

    add_index :last_dialogue_infos, :uid, unique: true
  end
end
