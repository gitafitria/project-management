class ChangeDatatypeRecipientOnInvoice < ActiveRecord::Migration[5.2]
  def change
    remove_column :invoices, :recipient
    add_column :invoices, :recipient_ids, :integer, array: true, default: []
  end
end
