class CreateProjects < ActiveRecord::Migration[5.2]
  def change
    create_table :projects do |t|
  		t.string :project_name
  		t.text :description
  		t.integer :user_id
  		t.boolean :is_valid
  		t.boolean :status
  		
      t.timestamps
    end
  end
end
