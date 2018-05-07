class Invoice < ApplicationRecord
	belongs_to :project
	has_many :invoice_items
end
