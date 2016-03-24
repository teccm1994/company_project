class AddFileToDocs < ActiveRecord::Migration
  def change
  	add_column :docs, :f_name, :string
  	add_column :docs, :f_url, :string
  end
end
