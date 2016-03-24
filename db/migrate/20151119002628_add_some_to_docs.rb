class AddSomeToDocs < ActiveRecord::Migration
  def change
  	add_column :docs, :comment, :string
  	add_column :docs, :doc_status, :integer
  	add_column :docs, :publish_time, :integer
  	add_column :docs, :p_user_id, :integer
  	add_column :docs, :examine_status, :integer
  	add_column :docs, :e_user_id, :integer
  	add_column :docs, :c_user_id, :integer
  	add_column :docs, :examine_time, :string
  end
end
