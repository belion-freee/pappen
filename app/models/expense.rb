class Expense < ApplicationRecord
  ITEM = %w[食費 レンタル代 宿泊料金 移動費 利用料金 雑費].freeze

  belongs_to :room_member, inverse_of: :expenses
  belongs_to :event,       inverse_of: :expenses, primary_key: :eid
  has_many :exempt_members, { inverse_of: :expense, dependent: :destroy }
  has_many :exempts, through: :exempt_members, source: :room_member

  validates :name,           presence: true
  validates :payment,        presence: true

  scope :summary, ->(event) {
    records = includes(:exempts, :room_member).where(event: event).to_a
    members = event.room_members
    return [] if records.blank?

    member_payment = {}
    records.each {|r|
      payment_members = members - r.exempts
      members.each {|m|
        member_payment[m.id] ||= { payment: 0, fee: 0 }
        payment = (m.id == r.room_member_id) ? r.payment : 0
        member_payment[m.id][:payment] += payment
        member_payment[m.id][:fee]     += payment_members.include?(m) ? r.payment.div(payment_members.count) : 0
      }
    }

    members.order(:id).map {|user|
      name = user.name
      amount = member_payment[user.id][:payment] - member_payment[user.id][:fee]
      {
        id:          user.id,
        room_member: name,
        payment:     member_payment[user.id][:payment],
        fee:         member_payment[user.id][:fee],
        amount:      amount.abs,
        paid:        amount.negative?,
      }
    }
  }
end
