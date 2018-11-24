class RoomMember < ApplicationRecord
  has_many :room_member_events, { inverse_of: :room_member, dependent: :destroy }, ->{ order(:id) }
  has_many :events, through: :room_member_events
  has_many :room_member_houses, { inverse_of: :room_member, dependent: :destroy }, ->{ order(:id) }
  has_many :houses, through: :room_member_houses
  has_many :expenses, dependent: :destroy
  has_many :house_expenditures, dependent: :destroy

  validates :uid, presence: true
  validates :name, presence: true

  scope :names, ->(gid) {
    where(gid: gid).map {|e| [e.id, e.name] }.to_h
  }
end
