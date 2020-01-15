class CreateExemptMembers < ActiveRecord::Migration[5.1]
  def change
    create_table :exempt_members do |t|
      t.belongs_to :expense, null: false, foreign_key: true
      t.belongs_to :room_member, null: false, foreign_key: true

      t.timestamps
    end
  end
end
