class AddColumnExpensesCurrency < ActiveRecord::Migration[5.1]
  def change
    add_column :expenses, :currency, :string, default: "JPY"
  end
end
