class CreateDocuments < ActiveRecord::Migration[5.2]
  def change
    create_table :documents do |t|
      t.string :document_name
      t.integer :project_id
      t.integer :user_id
      t.boolean :is_valid

      t.timestamps
    end
  end
end
