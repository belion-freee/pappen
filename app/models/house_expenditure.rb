class HouseExpenditure < ApplicationRecord
  CATEGORY = {
    food:    "食費",
    dining:  "外食費",
    another: "雑費",
    utility: "光熱費",
    travel:  "旅費",
    home:    "家賃",
  }.with_indifferent_access.freeze

  belongs_to :house, primary_key: :hid, inverse_of: :house_expenditures
  belongs_to :room_member, inverse_of: :house_expenditures
  has_many :house_expenditure_margins, dependent: :destroy
  accepts_nested_attributes_for :house_expenditure_margins

  validates :house_id,       presence: true
  validates :room_member_id, presence: true
  validates :entry_date,   presence: true
  validates :category,     presence: true
  validates :payment,      presence: true
  validate :margin_validation, if: -> { house_expenditure_margins.present? }

  scope :search, ->(id, date) {
    includes(:house_expenditure_margins).where(house_id: id, entry_date: date..date.end_of_month).order(entry_date: :desc)
  }

  scope :accounting, ->(records, members) {
    return [] if records.blank?
    count = members.count
    payments = records.group_by(&:room_member_id)
    members.order(:id).map {|user|
      payment = payments[user.id]&.map(&:payment)&.inject(:+) || 0
      repayment = records.map {|r|
        if r.house_expenditure_margins.present?
          hem = r.house_expenditure_margins.find {|f| f.room_member_id == user.id }
          hem.margin.nil? ? hem.fixed : (r.payment * (hem.margin.to_f / 100)).round
        else
          (r.payment.to_f / count).round
        end
      }
      repayment = repayment.map(&:to_i).inject(:+)
      {
        room_member: user.name,
        payment:     payment,
        repayment:   repayment,
        amount:      (payment - repayment),
      }
    }
  }

  scope :summary, -> {
    all.group_by(&:category).map {|category, arr|
      [category, arr.map(&:payment).inject(:+)]
    }.to_h
  }

  private

    def margin_validation
      margin_sum, fixed_sum = [:margin, :fixed].map {|key| house_expenditure_margins.map(&key).map(&:to_i).inject(:+) }

      return errors.add(:house_expenditure_margins, :only) unless [margin_sum, fixed_sum].one?(&:zero?)
      return errors.add(:house_expenditure_margins, :margin_sum) unless margin_sum.zero? || margin_sum == 100
      return errors.add(:house_expenditure_margins, :fixed_sum) unless fixed_sum.zero? || fixed_sum == self.payment
    end
end
