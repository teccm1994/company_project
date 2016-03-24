class AddLevelToCompany < ActiveRecord::Migration
  def change
  	add_column :companies, :level, :integer
  end
end
