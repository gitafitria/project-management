class AddDocFileToDocuments < ActiveRecord::Migration[5.2]
  def change
    add_column :documents, :doc_file, :string
  end
end
