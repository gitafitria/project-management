class Invoice < ApplicationRecord
	belongs_to :project
	has_many :invoice_items

  accepts_nested_attributes_for :invoice_items, :reject_if => lambda { |c| c[:description].blank? }, allow_destroy: true
end
