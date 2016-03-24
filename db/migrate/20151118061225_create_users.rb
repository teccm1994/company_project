class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :password
      t.integer :com_id
      t.string :type

      t.timestamps
    end
  end
end
