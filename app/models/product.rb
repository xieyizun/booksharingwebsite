class Product < ActiveRecord::Base
	attr_accessible :title, :description, :image_url, :price, :music_url, :flag, :buyer_id
	#书属于用户
	belongs_to :buyer
	#书拥有许多借阅项,评分
	has_many :items, dependent: :destroy
	has_many :comments, dependent: :destroy
  	#处理图片上传	
  	has_attached_file :avatar,
  	 	:styles => { :medium => "300x300>", :thumb => "100x100>"}, 
  	 	:default_url => "/images/:style/missing.png",
  	 	:url => '/images/:id/:style/:basename.:extension',
  	 	:path => ':rails_root/public/images/:id/:style/:basename.:extension'
  	 validates_attachment_presence :avatar
  	 validates_attachment_size :avatar, :less_than => 5.megabytes
  	 validates_attachment_content_type :avatar, :content_type => %w(image/jpeg image/png)

	#设置完之后记得执行: rake sunspot:solr:reindex
	#searchable do
	#	text :title, :description
		
	#	time :created_at	
	#end
end
