class CreateRoomMemberHouses < ActiveRecord::Migration[5.1]
  def change
    create_table :room_member_houses do |t|
      t.belongs_to :house,       null: false, foreign_key: true
      t.belongs_to :room_member, null: false, foreign_key: true

      t.timestamps
    end
  end
end
