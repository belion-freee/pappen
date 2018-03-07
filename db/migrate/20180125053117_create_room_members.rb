class CreateRoomMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :room_members do |t|
      ## Database authenticatable
      t.string :gid
      t.string :uid,   null: false
      t.string :name,  null: false

      t.timestamps
    end
  end
end
