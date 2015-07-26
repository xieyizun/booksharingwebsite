class AddBuyerIdToProducts < ActiveRecord::Migration
  def change
  		add_column :products, :buyer_id, :integer
    	add_index :products, :buyer_id
  end
end
