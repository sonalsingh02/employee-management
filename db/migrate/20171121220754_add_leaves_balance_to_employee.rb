class AddLeavesBalanceToEmployee < ActiveRecord::Migration[5.1]
  def change
    add_column :employees, :leaves_balance, :integer , null: false, default: 10
  end
end
