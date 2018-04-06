class LastMaximInfo < ApplicationRecord
  belongs_to :maxim, inverse_of: :last_maxim_infos

  validates :maxim_id, presence: true
end
