class AddColumnEventsCurrency < ActiveRecord::Migration[5.1]
  def change
    add_column :events, :currency, :string, default: "JPY"
  end
end
