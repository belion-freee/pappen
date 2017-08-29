class CreateMaxims < ActiveRecord::Migration[5.1]
  def change
    create_table :maxims do |t|
      t.string :category
      t.string :remark
      t.string :author
      t.string :source
      t.string :url

      t.timestamps
    end
  end
end
