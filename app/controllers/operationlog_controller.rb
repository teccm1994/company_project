class OperationlogController < ApplicationController

	#doc start
	#name:index
	#desp:调用index.html.erb日志列表
	#params:none
	#coder:chenming
	#release time:2015.11.23
	#doc end
	def index
		logger.info session[:user_id]
		# @user = User.find(session[:user])
		# @oplog = @user.operationlogs
		@oplogs = Operationlog.where(:user_id=>session[:user_id])
		@com_id = User.find(session[:user_id]).com_id
	end

	#doc start
	#name:echarts
	#desp:调用echarts.html.erb,显示报表
	#params:none
	#doc end
	def echarts
	end
	
end
