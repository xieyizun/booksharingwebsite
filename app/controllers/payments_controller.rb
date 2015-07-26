class PaymentsController < ApplicationController
  #只有登陆的用户可以对自己的书单进行提交
  #只有书单中存在书籍才能进行提交,不能提交一个空的书单.
  before_filter :sign_in_buyer
  before_filter :order_empty?, :cal_totalcost, only: [:new, :create]

  def new
  end
  #处理提交的书单,更新书单状态
  def create
  	if create_order?
      if current_order.update_attribute(:status, "Added")
        flash[:success] = "书单#{current_order.id}提交成功!"
  		  delete_order
  		  redirect_to current_buyer
      else
        flash[:warning] = "添加失败!"
        redirect_to current_order
      end
  	else
  		flash[:error] = "所有书单均已提交!"
  		redirect_to current_buyer
  	end
  end

  private 
  #判断书单是否为空
    def order_empty?
      if create_order? and current_order.items.count == 0
        flash[:notice] = "当前书单为空!"
        redirect_to current_order
      end
    end
end
