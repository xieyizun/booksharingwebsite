class Item < ActiveRecord::Base
	attr_accessible :product_id, :order_id, :product_name, :product_price, :commentable
	#书单项属于书和书单
	belongs_to :product
	belongs_to :order
	#每个书单项用于一个评分
	has_one :comment
end
