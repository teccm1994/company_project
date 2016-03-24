class CreateDocs < ActiveRecord::Migration
  def change
    create_table :docs do |t|
      t.string :title
      t.string :content
      t.integer :com_id

      t.timestamps
    end
  end
end
