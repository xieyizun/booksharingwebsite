class StaticPagesController < ApplicationController
	#home方法主要处理网站的主页请求
	def home
		#分页显示主目录的书籍,每页16本书
		@products = Product.paginate(page: params[:page], :per_page => 16)

		session.delete(:return_to)
		@product = Product.new
	end
	#处理所有非法路由,定位到404页面
	def error404
		render file: "#{Rails.root}/public/404.html", status: 404, layout: false
	end
end
