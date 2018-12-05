class AddIsTaxIncludedToInvoice < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :is_tax_included, :boolean, null: false, default: true
  end
end