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

  # TODO: only create.
  # Because it's no way to resolve which house expenditure has related to expenditure.
  after_create :sync_expenditure, if: -> { category != "food" }

  validates :house_id,       presence: true
  validates :room_member_id, presence: true
  validates :entry_date,   presence: true
  validates :category,     presence: true
  validates :payment,      presence: true
  validate :margin_validation, if: -> { house_expenditure_margins.present? }

  scope :search, ->(id, date) {
    includes(:house_expenditure_margins).where(house_id: id, entry_date: date..date.end_of_month).order(entry_date: :desc)
  }

  class << self
    def accounting(records, members)
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
    end

    def summary
      all.group_by(&:category).map {|category, arr|
        [category, arr.map(&:payment).inject(:+)]
      }.to_h
    end

    def monthly_summary(house_id, period = nil)
      period ||= Time.now.ago(6.month).beginning_of_month..Time.now.end_of_month
      column = "date_trunc('month', entry_date)::date"
      where(house_id: house_id, entry_date: period).group(column).order(column).sum(:payment)
    end
  end

  private

    def margin_validation
      margin_sum, fixed_sum = [:margin, :fixed].map {|key| house_expenditure_margins.map(&key).map(&:to_i).inject(:+) }

      return errors.add(:house_expenditure_margins, :only) unless [margin_sum, fixed_sum].one?(&:zero?)
      return errors.add(:house_expenditure_margins, :margin_sum) unless margin_sum.zero? || margin_sum == 100
      return errors.add(:house_expenditure_margins, :fixed_sum) unless fixed_sum.zero? || fixed_sum == self.payment
    end

    def sync_expenditure
      # TODO: It is better to add sync flg to house
      uids = self.house.room_members.map(&:uid)
      LineUser.where(uid: uids).each {|user|
        next if user.expenditures.blank?

        # set expenditure data
        case self.category.to_sym
        when :dining
          expenditure_category = self.payment > 5000 ? "接待交際費" : "会議費"
          expenditure_payment  = self.payment
        when :another
          expenditure_category = convert_sync_category || "雑費"
          expenditure_payment  = self.payment
        when :utility
          expenditure_category = "水道光熱費"
          expenditure_payment  = (self.payment * 0.5).round
        when :travel
          expenditure_category = convert_sync_category || "旅費交通費"
          expenditure_payment  = self.payment
        when :home
          expenditure_category = "地代家賃"
          expenditure_payment  = (self.payment * 0.7).round
        else
          raise "Unknown category"
        end

        Expenditure.create(
          line_user_id: user.id,
          entry_date:   self.entry_date,
          category:     expenditure_category,
          payment:      expenditure_payment,
          memo:         self.name
        )
      }
    end

    def convert_sync_category
      return nil unless self.name
      if self.name.match?(/航空|チケット|新幹線/)
        "研究開発費"
      elsif self.name.match?(/映画/)
        "新聞図書費"
      elsif self.name.match?(/購入/)
        "消耗品費"
      else
        nil
      end
    end
end
