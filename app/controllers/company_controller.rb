class CompanyController < ApplicationController
	#doc start
	#以下为由JS实现主页面的方法代码
	def delete
	end

	def main
	end

	def getCompany
		@companies = Company.where(:pre_id=>params[:id])
		render :json =>@companies.to_json
	end

	def edit
		@company = Company.find(params[:id])
		@company.name = params[:name]
		@company.save
		render :text => "success"
	end
	#doc end

	#doc start
	#name:add
	#desp:新建文档
	#params:none
	#coder:chenming
	#release time:2015.11.20
	#doc end
	def add
		company = Company.new
		company.name = params[:name] 
		company.pre_id = params[:com_id]

		@f_com = Company.find(params[:com_id])
		company.level = @f_com.level+1
		company.save
		redirect_to "/company/index?id=#{params[:com_id]}"
	end

	#doc start
	#name:create
	#desp:创建文档
	#params:pre_id父部门id
	#doc end
	def create
		@pre_id = params[:id]
	end

	#doc start
	#name:update
	#desp:调用update.html.erb，提交后触发update2方法
	#params:com_id所在部门id
	#doc end
	def update
		@company = Company.find(params[:id])
	end

	#doc start
	#name:update2
	#desp:接收update提交的内容，并保存至数据库
	#params:@company.id,@company.pre_id
	#doc end
	def update2
		@company = Company.find(params[:id])#select  * from Doc where id= "id"
		@company.name = params[:name]
		@company.save
		redirect_to "/company/index?id=#{@company.pre_id}"
	end

	#doc start
	#name:delete2
	#desp:部门删除
	#params:当前部门id
	#doc end
	def delete2
		@company = Company.find(params[:id])
		@com_id = @company.pre_id
		@company.delete
		#redirect_to "/company/index?id=#{@com_id}"
	end

	#doc start
	#name:index
	#desp:调用公司首页index.html.erb
	#params:pre_id父部门id
	#doc end
	def index
		@pre_id = params[:id]
		if @pre_id == '1'
			@cur_com = Company.new
			@cur_com.pre_id = 1
			@cur_com.name = "总部"
			@cur_com.id= 1
			@companies = Company.where(:pre_id=>@pre_id)
		else
			@cur_com = Company.find(params[:id])
			@companies = Company.where(:pre_id=>params[:id])
		end

	end

	#doc start
	#name:findAll2
	#desp:找到当前部门所有下属部门
	#params:com_id所在部门id
	#doc end
 	def findAll2(com_id)
 		@coms = Company.where(:pre_id=>com_id)
 		if @coms.size != nil
 			@coms.each do |com|
 				@@all_companies << com
 				findAll2 com.id
			end
 		end
 	end

	#doc start
	#name:findAll
	#desp:测试是否能找到当前部门及其所有子部门
	#params:none
	#doc end
 	def findAll
 		@@all_companies = []
 		logger.info "-------------error-----------#{@@all_companies.size}-----"

 		@companys = findAll2 126
 		logger.info "-------------error-----------#{@companys.size}-----"
 	end


end
