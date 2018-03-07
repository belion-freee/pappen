class Expense < ApplicationRecord
  belongs_to :room_members
  belongs_to :event

  validates :name,           presence: true
  validates :event_id,       presence: true
  validates :room_member_id, presence: true
  validates :payment,        presence: true
end
