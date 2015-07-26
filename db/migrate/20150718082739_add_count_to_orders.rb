class AddCountToOrders < ActiveRecord::Migration
  def change
  		add_column :orders, :count, :integer
  end
end
