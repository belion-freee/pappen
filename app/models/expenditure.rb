class Expenditure < ApplicationRecord
  ITEM = %w[
    接待交際費
    取材費
    旅費交通費
    会議費
    広告宣伝費
    研究開発費
    新聞図書費
    消耗品費
    雑費
    減価償却費
    水道光熱費
    地代家賃
    通信費
    開業費
    租税公課
  ].freeze

  attr_accessor :margin

  belongs_to :line_user, inverse_of: :expenditures

  validates :line_user_id, presence: true
  validates :entry_date,   presence: true
  validates :category,     presence: true
  validates :payment,      presence: true

  before_save :default_entry_date
  before_save :calc_margin, if: proc {|expenditure| expenditure.margin.present? }

  scope :search, ->(params) {
    res = where(line_user_id: params[:line_user_id])

    res = res.where(category: params[:category][:name]) if params.try(:[], :category).try(:[], :name).present?

    from = params.try(:[], :from_date).try(:to_date)
    to   = params.try(:[], :to_date).try(:to_date)

    if from || to
      from ||= Time.now.beginning_of_year.to_date
      to   ||= Time.zone.today
      res = res.where(entry_date: from..to)
    end

    res.order(entry_date: :desc)
  }

  scope :summary, -> {
    all.group_by(&:category).map {|category, arr|
      [category, arr.map(&:payment).inject(:+)]
    }.to_h
  }

  private

    def default_entry_date
      self.entry_date ||= Time.zone.today
    end

    def calc_margin
      self.payment = (self.payment * (self.margin.to_f / 100)).round
    end
end
