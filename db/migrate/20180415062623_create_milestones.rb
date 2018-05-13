class CreateMilestones < ActiveRecord::Migration[5.2]
  def change
    create_table :milestones do |t|
      t.string :label
      t.string :goal
      t.integer :project_id
      t.integer :user_id
      t.boolean :is_valid
      
      t.timestamps
    end
  end
end
