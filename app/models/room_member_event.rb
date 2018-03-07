class RoomMemberEvent < ApplicationRecord
  belongs_to :room_members
  belongs_to :event
end
