class RoomMemberHouse < ApplicationRecord
  belongs_to :room_member, inverse_of: :room_member_houses
  belongs_to :house,       inverse_of: :room_member_houses
end
