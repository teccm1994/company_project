class PTimeToDocs < ActiveRecord::Migration
def change
	add_column :docs, :p_time, :string
end

end
