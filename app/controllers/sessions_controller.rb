class SessionsController < ApplicationController
	def new
	end
	#处理用户登陆请求,即创建一个会话
	def create
	  #检测是否已经登陆
	  if sign_in?
			flash[:warning] = "你已经登陆!"
			redirect_to current_buyer
	  else
		buyer = Buyer.find_by_email(params[:session][:email].downcase)
		if buyer && buyer.authenticate(params[:session][:password])
			flash[:success] = "登陆成功!"
			sign_in buyer
			@unpaid_order = current_buyer.orders.find_by_status("UnAdded")
			if !@unpaid_order.nil?	
				create_order @unpaid_order
			end
			redirect_back_or_to current_buyer
		else
			flash[:error] = "邮箱或密码错误"
			render new_session_path
		end
	  end
	end
	#处理退出请求
	def destroy
		#delete_order定义在helper目录的order_helper.rb
		#sign_out定义在helper目录的session_helper.rb
		delete_order
		sign_out
		redirect_to root_url
	end
end
