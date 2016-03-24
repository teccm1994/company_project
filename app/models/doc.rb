class Doc < ActiveRecord::Base
  attr_accessible :com_id, :content, :title, :comment, :doc_status, :publish_time, :p_user_id, :exmaine_status, :e_user_id, :c_user_id, :exmaine_time
  # validates :title, :content, presence: true,uniqueness: true
  
end
