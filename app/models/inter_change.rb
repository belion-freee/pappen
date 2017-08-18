class InterChange < ApplicationRecord
  validates :prefectures, presence: true
  validates :ic,          presence: true
end
