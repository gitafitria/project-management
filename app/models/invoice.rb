class Invoice < ApplicationRecord
	belongs_to :project
	has_many :invoice_items

	accepts_nested_attributes_for :invoice_items, :reject_if => lambda { |c| c[:description].blank? }, allow_destroy: true
	
	scope :this_month, -> {where(created_at: Time.now.beginning_of_month..Time.now.end_of_month)}

	def new_invoice_number
		num = sprintf '%02d', (Invoice.this_month.count + 1)
		return "#{Time.zone.now.year}#{Time.zone.now.month}#{Time.zone.now.day}#{num}"
	end

	def total_amount
		total_each  = self.invoice_items.map{|ii| ii.quantity * ii.unit_price}
		total = 0
		total_each.each do |t|
			total = total + t
		end
		return total
	end
end
