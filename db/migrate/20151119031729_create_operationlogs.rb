class CreateOperationlogs < ActiveRecord::Migration
  def change
    create_table :operationlogs do |t|
      t.string :time
      t.string :desc
      t.integer :user_id

      t.timestamps
    end
  end
end
