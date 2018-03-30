class AddColumnRoomMemberEvents < ActiveRecord::Migration[5.1]
  def change
    add_column :room_member_events, :paid, :boolean, default: false
  end
end
