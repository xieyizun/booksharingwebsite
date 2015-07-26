class BuyersController < ApplicationController
  #过滤器,确保用户只有登陆之后才能进行编辑更新用户资料
  #用户只能更新自己的用户资料和查看自己的资料
  before_filter :sign_in_buyer, only: [:edit, :update, :show]
  before_filter :correct_buyer, only: [:edit, :update, :show]
  
  def new
    #sign_in?方法判断用户是否已经登陆,该方法的定义在helper目录的session_helper.rb里面
    if sign_in?
      flash[:warning] = "你已经登陆!"
      redirect_to current_buyer
    else
      @buyer = Buyer.new
    end
  end
  #处理提交的创建用户请求
  def create
      params.permit!
      @buyer = Buyer.new(params[:buyer])
      if @buyer.save
        flash[:success] = "注册成功!"
        sign_in @buyer
        redirect_to current_buyer
      else
        render new_buyer_path
      end
  end

  def edit
  end
  #处理提交的更新用户资料的请求
  def update
      if @buyer.update_attributes(params[:buyer])
        flash[:success] = "成功更新用户资料!"
        sign_in @buyer
        redirect_to current_buyer
      else
        flash[:warning] = "更新失败!"
        redirect_to edit_buyer_path
      end
  end
  #处理显示用户资料请求
  def show
    @orders = current_buyer.orders.paginate(page: params[:page]) 
  end
  #处理显示用户发布的图书的请求
  def mybooks
    @mybooks = current_buyer.products.paginate(page: params[:page])
  end
  #处理管理用户发布的图书的请求,包括修改和删除图书
  def managemybooks
    @mybooks = current_buyer.products.paginate(page: params[:page])
  end
  def index
  end

  def destroy
  end

  private
    #判断是否为正确的用户,即防止其他用户通过url访问其他用户的资料
    def correct_buyer
      @buyer = Buyer.find_by_id(params[:id])
      unless !@buyer.nil? and @buyer.id == current_buyer.id
        flash[:warning] = "你没有权限访问其他用户的资料!"
        redirect_to current_buyer
      end
    end
end
