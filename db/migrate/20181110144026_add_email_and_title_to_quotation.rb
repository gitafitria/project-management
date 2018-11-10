class AddEmailAndTitleToQuotation < ActiveRecord::Migration[5.2]
  def change
    add_column :quotations, :email, :string
    add_column :quotations, :title, :string
  end
end
