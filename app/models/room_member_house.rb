class RoomMemberHouse < ApplicationRecord
  belongs_to :room_member, inverse_of: :room_member_houses
  belongs_to :house,       primary_key: :hid, inverse_of: :room_member_houses
end
