class CreateLastDialogueInfos < ActiveRecord::Migration[5.1]
  def change
    create_table :last_dialogue_infos do |t|
      t.string :uid
      t.string :mode
      t.string :context

      t.timestamps
    end
  end
end
