class RemoveProjectClients < ActiveRecord::Migration[5.2]
  def change
    drop_table :project_clients
  end
end
