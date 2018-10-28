class ProjectClient < ActiveRecord::Migration[5.2]
  def change
    create_table :project_clients do |t|
      t.integer :project_id
      t.integer :user_id      
    end
  end
end
