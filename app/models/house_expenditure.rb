class HouseExpenditure < ApplicationRecord
  CATEGORY = %w[固定支出 定期支出 一般支出].freeze

  belongs_to :house, inverse_of: :house_expenditures
  belongs_to :room_member, inverse_of: :house_expenditures

  validates :entry_date,   presence: true
  validates :category,     presence: true
  validates :payment,      presence: true

  scope :search, ->(params) {
    res = where(house_id: params[:house_id])

    res = res.where(category: params[:category][:name]) if params.try(:[], :category).try(:[], :name).present?

    from = params.try(:[], :from_date).try(:to_date)
    to   = params.try(:[], :to_date).try(:to_date)

    if from || to
      from ||= Time.zone.today
      to   ||= Time.now.beginning_of_year.to_date
      res = res.where(entry_date: from..to)
    end

    res.order(entry_date: :desc)
  }

  scope :summary, -> {
    all.group_by(&:category).map {|category, arr|
      [category, arr.map(&:payment).inject(:+)]
    }.to_h
  }
end
