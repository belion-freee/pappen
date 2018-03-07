class Event < ApplicationRecord
  has_many :room_member_events, { inverse_of: :room_member, dependent: :destroy }, ->{ order(:id) }
  has_many :room_members, through: :room_member_events
  has_many :expenses, dependent: :destroy

  validates :name, presence: true, uniqueness: true
end
