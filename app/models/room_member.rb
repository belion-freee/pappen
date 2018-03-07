class RoomMembers < ApplicationRecord
  has_many :room_member_events, { inverse_of: :room_member, dependent: :destroy }, ->{ order(:id) }
  has_many :events, through: :room_member_events
  has_many :expenses, dependent: :destroy

  validates :gid
  validates :uid, presence: true
  validates :name, presence: true
end
