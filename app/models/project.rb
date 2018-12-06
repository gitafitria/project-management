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
  scope :by_clients, -> by_clients do
    # value_variable = ANY ('{1,2,3}'::int[]
    where("projects.client_ids @> ARRAY[?]", by_clients.map{|c| c.to_i})
  end
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

  def clients
    Client.where("id IN (?)", self.client_ids)
  end

  def self.total_grouped_by_month_this_year
    today = Date.today
    orders = where(created_at: today.beginning_of_year..today).where(is_valid: true)
    orders = orders.group("extract(month from created_at)")
    orders = orders.select("extract(month from created_at) as month_project, count(*) as total_project")
    orders.group_by{|o| o.month_project}

    data = {}
    orders.each { |e| data[e.month_project.to_i] = e.total_project }

    record = {}
    (1..12).each do |e|
      count = data[e].nil? ? 0 : data[e]
      record["#{e}"] = count
    end

    record
  end
end
