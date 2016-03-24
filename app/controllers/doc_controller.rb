class DocController < ApplicationController
	#doc start
	#以下为由JS实现主页面的方法代码
	def edit
		@doc = Doc.find(params[:id])
		@doc.title = params[:title]
		@doc.content = params[:content]
		@doc.save
		render :text => "success"
	end

	def delete
		@doc = Doc.find(params[:id])
		@doc.delete
		render :text => "success"
	end

	def getDoc
		@docs = Doc.where(:com_id => params[:id])
		render :json => @docs.to_json
	end
	#doc end
	
	#doc start
	#name:add
	#desp:新建文档
	#params:none
	#coder:liming
	#release time:2015.11.20
	#doc end
	def add
		doc = Doc.new
		doc.title = params[:title] 
		doc.content = params[:content]
		doc.com_id = params[:com_id]
		doc.doc_status = 1
		doc.p_time = Time.now

		doc.p_user_id = session[:user_id]
		doc.examine_status = 0

		tmp = params[:myfile]
		logger.info "___#{Rails.root}__________#{tmp.original_filename}______#{tmp.path}________________"
		@filename = tmp.original_filename
		File.open("#{Rails.root}/public/#{@filename}","wb") do |f|
			f.write(tmp.read)
		end

		doc.f_name = tmp.original_filename
		doc.f_url = "public/#{@filename}"

		if doc.save
			savelog "create new doc"
			redirect_to "/doc/new?id=#{doc.com_id}"
		else
			redirect_to "/doc/new?id=#{doc.com_id}"
		end
		savelog "publish the doc"
	end

	#doc start
	#name:update
	#desp:调用update.html.erb，提交后触发update2方法
	#params:@doc.id,@doc.com_id
	#doc end
	def update
		@doc = Doc.find(params[:id])
	end

	#doc start
	#name:update2
	#desp:接收update提交的内容，并保存至数据库
	#params:@doc.id,@doc.com_id
	#doc end
	def update2
		@doc = Doc.find(params[:id])#select  * from Doc where id= "id"
		@doc.title = params[:title]
		@doc.content = params[:content]
		if @doc.save
			savelog "update doc"
			redirect_to "/doc/new?id=#{@doc.com_id}"
		else
			@doc = Doc.find(params[:id])
			redirect_to "doc/update?id=#{@doc.com_id}"
		end
	end

	#doc start
	#name:delete2
	#desp:文档删除
	#params:当前文档id
	#doc end
	def delete2
		@doc = Doc.find(params[:id])
		@com_id = @doc.com_id
		@doc.delete
		savelog "delete doc"
		redirect_to "/doc/new?id=#{@com_id}"
	end

	#doc start
	#name:delete2
	#desp:文档列表首页
	#params:当前文档id
	#doc end
	def new
		# @docs = Doc.where(:com_id=>params[:id])

		# @user = User.find(session[:user_id])
		# @user_com = Company.find(@user.com_id)
	 	# 	@doc_com = Company.find(params[:id])
	 	# 	if @user_com.level <= @doc_com.level
	 	# 		@docs = Doc.where(:com_id=>params[:id])
	 	# 		@com_id = params[:id]
	 	# 	else
	 	# 		redirect_to "/doc/nopermission"
		# end
		@com_id = params[:id]
		@@all_docs = []
		if @com_id == ""
			@com_id = '1'
		end

		#数组实现分页
		@page_num = params[:page_num]
		if @page_num == nil
			@page_num = '1'
		end
		@page_num = @page_num.gsub(' ','')
		@page_num = @page_num.to_i
		start_d = (@page_num - 1) * 6
		end_d = (@page_num - 1) * 6 + 5

		if haspermission @com_id		
			findAllDoc2 @com_id
			if @@all_docs.size % 6 == 0
				@record_count = @@all_docs.size / 6
			else
				@record_count = @@all_docs.size / 6 + 1
			end
			logger.info "---#{@record_count}-----#{@@all_docs.size}----------"
			@docssss = @@all_docs[start_d..end_d]
			#kaminari实现分页
			# @docssss = Doc.page(params[:page_num]).per(10)
			
		else
			redirect_to "/doc/nopermission"
		end
	end
 	
	#doc start
	#name:create
	#desp:创建文档
	#params:当前文档所在部门id
	#doc end
 	def create
		@com_id = params[:id]
 	end

 	#doc start
	#name:delete3
	#desp:软删除文档
	#params:当前文档所在部门id
	#doc end
 	def delete3 
 		@doc = Doc.find(params[:id])
 		@com_id = @doc.com_id
 		@doc.doc_status = 0
 		@doc.save
 		savelog "soft delete savelog"
 		redirect_to "/doc/new?id=#{@com_id}"
 	end

 	#doc start
	#name:recovery
	#desp:恢复软删除文档
	#params:当前文档所在部门id
	#doc end
 	def recovery
 		@doc = Doc.find(params[:id])
 		@com_id = @doc.com_id
 		@doc.doc_status = 1
 		@doc.save
 		savelog "recovery doc"
 		redirect_to "/doc/new?id=#{@com_id}"
 	end

 	#doc start
	#name:toexamine
	#desp:调用toexamine.html.erb页面，提交后调用examine方法
	#params:当前文档所在部门id
	#doc end
 	def toexamine
 		@doc = Doc.find(params[:id])
 	end

 	#doc start
	#name:examine
	#desp:接收toexamine方法传输的数据，并存至数据库
	#params:当前文档所在部门id
	#doc end
 	def examine 
 		@doc = Doc.find(params[:id])

 		@user = User.find(session[:user_id])

 		@doc_com = Company.find(@doc.com_id)
 		@user_com = Company.find(@user.com_id)
 		@com_id = @doc.com_id
 		if @user_com.level <= @doc_com.level
	 		if @doc.examine_status == 0
	 			@doc.examine_time = Time.now
	 			@doc.e_user_id = session[:user_id]
	 			@doc.comment = params[:comment]
	 			@doc.examine_status = 1
	 			@doc.save
	 			savelog "examine doc "
	 		    redirect_to "/doc/new?id=#{@com_id}"
		 	else
		 		redirect_to "/doc/new?id=#{@com_id}"
		 	end
		else
			redirect_to "/doc/nopermission?id=#{@doc.id}"      			
		end 		
 	end

 	#doc start
	#name:nopermission
	#desp:调用nopermission.html.erb页面提示无权限
	#params:none
	#doc end
 	def nopermission
 	end

 	#doc start
	#name:savelog
	#desp:新建Operationlog类，保存当前操作的系列信息
	#params:操作描述desc
	#doc end
 	def savelog(desc)
 		oplog = Operationlog.new
 		oplog.time = Time.now
 		oplog.desc = desc
 		oplog.user_id = session[:user_id]
 		oplog.save
 	end

	#doc start
	#name:findAllDoc2
	#desp:查找当前所在部门及其子部门的所有文档
	#params:com_id当前文档所在部门id
	#doc end
	def findAllDoc2(com_id)
		if haspermission com_id
			@docs = Doc.where(:com_id => com_id)
			@docs.each do |doc|
			 	@@all_docs << doc
			end
			@coms = Company.where(:pre_id => com_id)
			if @coms.size != nil
				@coms.each do |com|
					findAllDoc2 com.id
				end
			end
		end
	end

	#doc start
	#name:haspermission
	#desp:判断有无权限
	#params:com_id当前文档所在部门id
	#doc end
	def haspermission(com_id)
 		user = User.find(session[:user_id])
 		if com_id == '1'
 			return false
 		end
 		cur_com = Company.find(com_id)
 		user_com = Company.find(user.com_id)

 		if user_com.level <= cur_com.level
 			logger.info "-------------has permission ---------"
 			return true
 		else
 			logger.info "-------------no permission ---------"
 			return false
 		end
	end

	#doc start
	#name:query
	#desp:按条件查询相关文档
	#params:com_id当前文档所在部门id
	#doc end
 	def query
 		if params[:p_time] != ""
 			q_time = Time.parse params[:p_time]
 		else
 			q_time = Time.now
 		end
 		if params[:examine_time] != ""
 			e_time = Time.parse params[:examine_time]
 		else
 			e_time =Time.now
 		end
 		@@all_docs = []
 		@com_id = params[:com_id]
 		if haspermission @com_id		
			querydoc @com_id,q_time,params[:examine_status],e_time 
			@docs = @@all_docs
			
		else
			redirect_to "/doc/nopermission"
		end
 	end

 	#doc start
	#name:querydoc
	#desp:按条件查询相关文档
	#params:p_time发布时间,examine_time审核时间,examine_status审核状态
	#doc end
	def querydoc(com_id,q_time,examine_status,e_time)
		if haspermission com_id 
			if examine_status =='0'
	 			@docs = Doc.where(:com_id => com_id).where("p_time <=?",q_time)
	 			.where(:examine_status => examine_status)
	 		else		
	 			@docs = Doc.where(:com_id => com_id).where("p_time <=?",q_time).where(:examine_status => examine_status)
	 			.where("examine_time <= ?",e_time)
	 		end
	 		@docs.each do |doc|
			 	@@all_docs << doc
			end
			@coms = Company.where(:pre_id => com_id)
			if @coms.size != nil
				@coms.each do |com|
					querydoc com.id,q_time,examine_status,e_time
				end
			end
		end
	end

	#doc start
	#name:getCompanyName
	#desp:返回部门名称
	#params:com_id当前文档所在部门id
	#doc end
 	def getCompanyName
		@com_id = params[:com_id]
		if @com_id == ""
			@com_id = '1'
		end		
		companies = Company.where(:pre_id => @com_id)
		render :json => companies.to_json
 	end

 	#doc start
	#name:getDocCount
	#desp:获取部门文档数
	#params:当前文档所在部门id
	#doc end
 	def getDocCount
 		@com_id = params[:com_id]
 		if @com_id == ""
			@com_id = '1'
		end		
 		companies = Company.where(:pre_id => @com_id)
 		count_s = []
 		companies.each do |company|
 			@count_ss = 0
 			@count_e = 0
 			findAllDoc3 company.id
 			count_s << @count_ss 
 			count_s << @count_e
 		end
 		render :json => count_s.to_json
 	end

 	#doc start
	#name:findAllDoc3
	#desp:查找当前部门所有文档
	#params:com_id当前文档所在部门id
	#doc end
 	def findAllDoc3(com_id)
		docs = Doc.where(:com_id => com_id)
		docs.each do |doc|
		 	@count_ss += 1
		 	if(doc.examine_status == 1)
		 		@count_e += 1
		 	end
		end
		coms = Company.where(:pre_id => com_id)
		if coms.size != nil
			coms.each do |com|
				findAllDoc3 com.id
			end
		end
	end

	#doc start
	#name:upload
	#desp:上传文档调用upload.html.erb页面，提交后触发upload2
	#params:none
	#doc end
	def upload		
	end

	#doc start
	#name:upload2
	#desp:接收upload数据，打开文件并上传
	#params:上传文件名
	#doc end
	def upload2
		require 'fileutils'
		tmp = params[:myfile]
			@filename = tmp.original_filename
			File.open("#{Rails.root}/public/#{@filename}","wb") do |f|
				f.write(tmp.read)
			return @filename
		end
	end

	#doc start
	#name:getFileName
	#desp:获取文件名,判断文件名是否为空
	#params:文件名
	#doc end
	def getFileName(filename)
		if !filename.nil
			return filename
		end
	end

	#doc start
	#name:download
	#desp:下载文件
	#params:file_path,file_name
	#doc end
	def download
      file_path = params[:file_path]
      file_name = params[:file_name]
      if file_path != nil

	    if File.exist?(file_path)
	        io = File.open(file_path)
	        io.binmode
	        send_data(io.read,:filename => file_name,:disposition => 'attachment')
	        io.close
	    end
      end   
  end
end



