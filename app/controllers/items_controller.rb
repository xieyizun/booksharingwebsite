class ItemsController < ApplicationController
  #只有登陆了的用户才能进行书单项的操作
  before_filter :sign_in_buyer

  def new
  end

  #处理提交的创建书单项的请求,即添加书到书单里面
  def create
    #查看是否已经存在一个未提交的书单
    if create_order?
      @product = Product.find_by_id(params[:id])
      if @product.flag == 'n' #中途被人提前借走
          flash[:warning] = "你来晚了,图书已借出!"
          redirect_to @product
      end
      @item = Item.new(product_id:params[:id], order_id:current_order.id, 
          product_name:@product.title, product_price:@product.price, commentable:true)
      if @item.save
        @product.update(:flag => 'n') #更新flag表示已经借出
        redirect_to current_order
      else
        flash[:warning] = "借阅失败!"
        render @product
      end
    else
      flash[:warning] = "您还没有创建一个书单!"
      redirect_to @product
    end
  end
  #处理删除书单项的请求
  def destroy
      @product = current_order.items.find_by_id(params[:id]).product
      @product.update(:flag => 'y')
      current_order.items.find_by_id(params[:id]).destroy
    
      respond_to do |format|
          format.html {redirect_to current_order}
          format.js
      end
  end
  #处理显示书单项的请求
  def show
    current_buyer.orders.each do |order|
        @item = order.items.find_by_id(params[:id])
        if !@item.nil?
            break
        end
    end
    if !@item.nil?
      @product = Product.find_by_id(@item.product_id)
      if !@product.nil?
        @comment = Comment.new(product_id:@product.id, buyer_id:current_buyer.id, item_id:params[:id])
      else
        flash[:warning] = "这本书已经下架!"
        redirect_to current_buyer
      end
    else
      flash[:warning] = "这个书单项 #{params[:id]} 不存在或不属于你!"
      redirect_to current_buyer
    end
  end

  def index
    redirect_to current_buyer
  end
end
