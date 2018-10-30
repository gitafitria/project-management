class Project < ApplicationRecord
  enum status: PROJECT_STATUS

	has_many :milestones
	has_many :quotes
  has_many :invoices
  has_many :quotations
  has_many :documents
  belongs_to :user

  accepts_nested_attributes_for :milestones, allow_destroy: true

  validates :project_name, :user_id, :milestones, :status, presence: true

  before_create :set_valid
  # by_clients
  # scope :by_clients, -> by_clients { where("projects.clients in (?)", by_clients) }
  # by_creator
  scope :by_creators, -> by_creators { where("projects.user_id in (?)", by_creators) }
  # by_status
  scope :by_status, -> by_status do
    status_int = Project.statuses.select{|k, v| k.to_s == by_status}.values.first
    where("projects.status = ?", status_int)
  end
  scope :valid, -> * { where("projects.is_valid = ?", true) }

  def set_valid
    self.is_valid = true
  end

end
