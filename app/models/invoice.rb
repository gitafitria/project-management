class Invoice < ApplicationRecord
  belongs_to :project
  belongs_to :user
  belongs_to :recipient, class_name: "Client"
  has_many :invoice_items
  enum status: INVOICE_STATUS

  accepts_nested_attributes_for :invoice_items, :reject_if => lambda { |c| c[:description].blank? }, allow_destroy: true

  scope :this_month, -> {where(created_at: Time.now.beginning_of_month..Time.now.end_of_month)}

  # by_projects
  scope :by_projects, -> by_projects { where("invoices.project_id in (?)", by_projects) }
  # by_creators
  scope :by_creators, -> by_creators { where("invoices.user_id in (?)", by_creators) }
  # by_recipients
  scope :by_recipients, -> by_recipients { where("invoices.recipient in (?)", by_recipients) }
  # by_status
  scope :by_status, -> by_status do
    status_int = Invoice.statuses.select{|k, v| k.to_s == by_status}.values.first
    where("invoices.status = ?", status_int)
  end

  # VALIDATIONS
  validates :project_id, :user_id, :recipient, :status, :invoice_number, :subject, :due_date, :issue_date, presence: true
  validates :invoice_number, uniqueness: true

  def new_invoice_number
    last_num = Invoice.this_month.last.invoice_number[9..10].to_i
    num = sprintf '%02d', (last_num + 1)
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

  def self.projects_list
    Project.where("id IN (?)", Invoice.all.collect(&:project_id).uniq)
  end
end
