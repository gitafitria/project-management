class Project < ApplicationRecord
	has_many :milestones
	has_many :quotes
	has_many :invoices

end
