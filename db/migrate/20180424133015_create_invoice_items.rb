class CreateInvoiceItems < ActiveRecord::Migration[5.2]
  def change
    create_table :invoice_items do |t|
      t.string :description
      t.integer :quantity
      t.integer :unit_price
      t.integer :invoice_id
      t.boolean :is_valid

      t.timestamps
    end
  end
end
