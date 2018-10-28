class ChangeProjectStatusToInteger < ActiveRecord::Migration[5.2]
  def change
    remove_column :projects, :status, :boolean

    add_column :projects, :status, :integer
  end
end
