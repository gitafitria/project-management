class AddClientIdsToProject < ActiveRecord::Migration[5.2]
  def change
    add_column :projects, :client_ids, :integer, array: true, default: []
    # t.string :keywords, array: true, default: []
  end
end
