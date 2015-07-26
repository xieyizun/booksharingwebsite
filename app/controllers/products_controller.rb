class ProductsController < ApplicationController
  def new
    @product = Product.new(buyer_id: current_buyer.id)
  end
  #处理提交的新建订单的请求
  def create
    @new_product = current_buyer.products.build(params[:product])
    @new_product.avatar = params[:product][:avatar] #刚开始没加这句出问题
    @new_product.flag = 'y' #y表示可以借阅
    @new_product.price = 0
    if @new_product.save
      redirect_to '/mybooks'
    else
      flash[:warning] = "信息不完整"
      redirect_to new_product_path
    end
  end
  #处理显示所有订单的请求
  def index
    @toptens = Comment.find_by_sql("select product_id from comments where score == 111.0")
    if !@toptens.nil?
        @goodsongs = []
        @toptens.each do |topten|
            @goodsongs << Product.find_by_id(topten.product_id)
        end
    end
  end

  def edit
      @product = Product.find_by_id(params[:id])
  end
  #处理更新书籍的请求,对书籍状态在数据库进行修改
  def update
     @product = Product.find_by_id(params[:id])
     if !@product.nil? and @product.update_attributes(params[:product])
        flash[:success] = "图书信息更新成功!"
        redirect_to @product
     else
        flash[:warning] = "图书信息更新失败!"
        redirect_to edit_product_path
     end
  end
  #处理查看图书详细资料的请求
  def show
  	@product = Product.find_by_id(params[:id])
    if @product.nil?
        flash[:warning] = "图书不存在或已经下架!"
        redirect_to root_path
    else
       #获取该图书的评分数据
  	   @comments = @product.comments.paginate(page: params[:page], :per_page => 10) 

  	   if !sign_in?	
  		    store_url
  	   else
          if !create_order?
              store_url
          end
       end
    end
  end
  #处理图书搜索请求
  def search
    #使用solr搜索引擎进行搜索
	  #@goodsongs = Sunspot.search(Product) do
		#  keywords params[:query] do
    #    fields(:title)
    #  end
    #  order_by :created_at, :desc
    #end.results

    @goodsongs = Product.find_by_sql("SELECT id, title, description FROM products \
                  WHERE title LIKE '%#{params[:query]}%' ORDER BY products.created_at desc")
	  respond_to do |format|
		  format.html {render :action =>"index" }
		  format.xml { render :xml => @goodsongs }
	  end
  end
  #删除图书
  def destroy
      current_buyer.products.find_by_id(params[:id]).destroy #删除
      respond_to do |format|
          format.html {redirect_to managemybooks_buyers_path }
          format.js
      end
  end
end
