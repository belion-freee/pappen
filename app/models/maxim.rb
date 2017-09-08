class Maxim < ApplicationRecord
  validates :category, presence: true, if: :check_category
  validates :remark,   presence: true
  validates :author,   presence: true

  def check_category
    Settings.maxim.category.keys.include?(self.category)
  end
end
