class CreateRoomMemberHouses < ActiveRecord::Migration[5.1]
  def change
    create_table :room_member_houses do |t|
      t.string :house_id, null: false
      t.belongs_to :room_member, null: false, foreign_key: true

      t.timestamps
    end
    add_foreign_key :room_member_houses, :houses, column: :house_id, primary_key: :hid
    add_index  :room_member_houses, :house_id
  end
end
