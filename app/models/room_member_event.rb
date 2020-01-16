class RoomMemberEvent < ApplicationRecord
  belongs_to :room_member, inverse_of: :room_member_events
  belongs_to :event,       inverse_of: :room_member_events, primary_key: :eid
end
