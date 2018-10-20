class Project < ApplicationRecord
	has_many :milestones
	has_many :quotes
  has_many :invoices
  has_many :quotations
  has_many :documents

  accepts_nested_attributes_for :milestones, allow_destroy: true

  before_create :set_valid

  def set_valid
    self.is_valid = true
  end
end
