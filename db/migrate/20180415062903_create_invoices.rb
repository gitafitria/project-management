class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
    	t.integer :user_id
    	t.integer :project_id
    	t.string :invoice_number
    	t.date :issue_date
    	t.date :due_date
    	t.string :subject
    	t.integer :recipient
    	t.integer :status
    	t.float :tax
    	t.integer :total_payment
    	t.boolean :is_valid
    	 
      t.timestamps
    end
  end
end
