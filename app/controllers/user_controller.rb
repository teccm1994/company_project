class UserController < ApplicationController

	skip_before_filter :authorize

	#doc start
	#name:index
	#desp:调用index.html.erb,显示用户登录页面
	#params:none
	#coder:liming
	#release time:2015.11.23
	#doc end
	def index
	end

	#doc start
	#name:index
	#desp:接收用户登录信息，保存至数据库
	#params:none
	#doc end
	def login
		@user = User.where(:name => params[:name],:password => params[:password])
		 if @user.blank?
			logger.info "-------------error----------------"
			logger.info session[:user_id]
			redirect_to '/user/index'
		else
			logger.info "------------success-----------------------"
			session[:user_id] = @user[0].id
			session[:user_name] = @user[0].name
			logger.info session[:user_id]
		 	redirect_to "/company/index?id=#{@user[0].com_id}"
		 end
	end

	#doc start
	#name:logout
	#desp:退出登录
	#params:none
	#doc end
	def logout
		session[:user_id] = nil
		session[:user_name] = nil
		redirect_to "/user/login"
	end

	#doc start
	#name:tocreate
	#desp:创建用户
	#params:com_id当前部门id
	#doc end
	def tocreate 
		@com_id = params[:com_id]
		if @com_id == "1"
			redirect_to '/company/index'		
		end
	end

	#doc start
	#name:create
	#desp:接收用户注册信息，并保存至数据库
	#params:none
	#doc end
	def create
		user = User.new
		user.name = params[:name]
		user.password = params[:password]
		user.com_id = params[:com_id]
		user.user_type = params[:user_type]
		if user.save
			redirect_to '/user/index'
		else
			redirect_to '/user/tocreate'
		end
	end

	#doc start
	#name:show
	#desp:用户列表显示
	#params:com_id当前部门id
	#doc end
	def show
		@users = User.where(:com_id => params[:com_id])
		@com_id = params[:com_id]	
	end

	#doc start
	#name:delete
	#desp:删除用户
	#params:com_id当前部门id
	#doc end
	def delete
		@user = User.find(params[:id])
		@com_id = @user.com_id
		@user.delete
		redirect_to "/user/show?com_id=#{@com_id}"
	end
	
end
