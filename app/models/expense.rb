class Expense < ApplicationRecord
  ITEM = %w[食費 レンタル代 宿泊料金 移動費 利用料金 雑費].freeze

  belongs_to :room_member, inverse_of: :expenses
  belongs_to :event,       inverse_of: :expenses

  validates :name,           presence: true
  validates :payment,        presence: true

  scope :accounting, ->(records, members) {
    return [] if records.blank?
    fee = records.map(&:payment).inject(:+).div(members.count)
    [
      fee,
      members.order(:id).map {|user|
        name = user.name
        payment = records.select {|res| res.room_member_id == user.id }.map {|ex| ex[:payment] }.inject(:+) || 0
        amount = payment - fee
        {
          id:          user.id,
          room_member: name,
          payment:     payment,
          amount:      amount.abs,
          paid:        amount.negative?,
        }
      },
    ]
  }
end
