class LineUser < ApplicationRecord
  self.primary_key = "code"

  belongs_to :user, optional: true
  has_many :expenditures, dependent: :destroy

  validates :uid,   presence: true
  validates :name,  presence: true

  after_initialize :default_code, if: :new_record?

  def default_code(num = 10)
    self.code ||= SecureRandom.hex(num)
  end
end
