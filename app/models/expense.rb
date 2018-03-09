class Expense < ApplicationRecord
  ITEM = %w[宿泊料金 施設利用料金 高速料金 ガソリン代 レンタカー代 用品レンタル代 食費 酒代 飲み代 予約料金 雑費 その他].freeze

  belongs_to :room_member, inverse_of: :expenses
  belongs_to :event,       inverse_of: :expenses

  validates :name,           presence: true
  validates :event_id,       presence: true
  validates :room_member_id, presence: true
  validates :payment,        presence: true
end
