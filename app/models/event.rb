class Event < ApplicationRecord
  has_many :room_member_events, { inverse_of: :event, dependent: :destroy }, ->{ order(:id) }
  has_many :room_members, through: :room_member_events
  has_many :expenses, dependent: :destroy

  validates :name, presence: true, uniqueness: true
  validate :room_member_present?
  validate :group_uniq?

  scope :selected_gid, ->(gid) {
    joins(:room_members).where(room_members: { gid: gid })
  }

  def room_member_present?
    errors.add(:room_members, :blank) if self.room_member_ids.blank?
  end

  def group_uniq?
    errors.add(:room_members, :multiple_group) if self.room_members.map(&:gid).uniq.size > 1
  end
end
