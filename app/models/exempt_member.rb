class ExemptMember < ApplicationRecord
  belongs_to :expense, inverse_of: :exempt_members
  belongs_to :room_member, inverse_of: :exempt_members
end
