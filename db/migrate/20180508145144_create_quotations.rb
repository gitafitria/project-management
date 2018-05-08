class CreateQuotations < ActiveRecord::Migration[5.2]
  def change
    create_table :quotations do |t|
      t.string :content
      t.integer :user_id
      t.integer :project_id
      t.boolean :is_valid

      t.timestamps
    end
  end
end
