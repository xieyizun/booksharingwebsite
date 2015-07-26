class OrdersController < ApplicationController
  #过滤器:只有登陆了的用户才能执行的订单的各种操作
  before_filter :sign_in_buyer
  
  def new
  end
  #处理提交的新建书单的请求
  def create
    #如果当前有未提交的订单,则可以
    if create_order?
      flash[:warning] = "当前已经存在一个未提交书单,可以直接添加!"
      redirect_to current_order
    else
      @unpaid_order = Order.new(buyer_id:current_buyer.id)
      @unpaid_order.status = "UnAdded"
      @unpaid_order.count = 0                      
      if @unpaid_order.save
        #create_order定义在helper目录的order_helper.rb目录
        create_order @unpaid_order
        redirect_back_or_to current_order
      else
        flash[:warning] = "书单创建失败!"
        redirect_to current_buyer
      end
    end
  end

  def index
    redirect_to current_buyer
  end

  def edit
  end

  def update  
  end
  #处理显示书单详细资料请求
  def show 
    @order = current_buyer.orders.find_by_id(params[:id])  
    if @order.nil?
          flash[:warning] = "当前书单不存在或不属于你!"
          redirect_to current_buyer
    end
  end
  #删除书单
  def destroy
    @order = current_buyer.orders.find_by_id(params[:id])
    @order.items.each do |item|
        Product.update(item.product_id, :flag => 'y')
    end
    @order.delete
    respond_to do |format|
      format.html {redirect_to current_buyer}
      format.js
    end
  end
end
