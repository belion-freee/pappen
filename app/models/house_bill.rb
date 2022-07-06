class HouseBill < ApplicationRecord
  validates :house_id,   presence: true
  validates :entry_date, presence: true, uniqueness: { scope: :house_id }
  validates :user_id,    presence: true, on: :update

  before_validation :setup_entry_date, if: -> { entry_date.present? }

  private

  def setup_entry_date
    self.entry_date = entry_date.to_date.beginning_of_month
  end
end
