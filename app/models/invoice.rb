class Invoice < ApplicationRecord
  belongs_to :project
  belongs_to :user
  # belongs_to :recipient, class_name: "Client"
  has_many :invoice_items
  enum status: INVOICE_STATUS

  accepts_nested_attributes_for :invoice_items, :reject_if => lambda { |c| c[:description].blank? or c[:unit_price].blank? or c[:quantity].blank?  }, allow_destroy: true

  scope :this_month, -> {where(created_at: Time.now.beginning_of_month..Time.now.end_of_month)}

  # by_projects
  scope :by_projects, -> by_projects { where("invoices.project_id in (?)", by_projects) }
  # by_creators
  scope :by_creators, -> by_creators { where("invoices.user_id in (?)", by_creators) }
  # by_recipients
  scope :by_recipients, -> by_recipients do
    where("invoices.recipient_ids @> ARRAY[?]", by_recipients.map{|c| c.to_i})
  end
  # by_status
  scope :by_status, -> by_status do
    status_int = Invoice.statuses.select{|k, v| k.to_s == by_status}.values.first
    where("invoices.status = ?", status_int)
  end
  # by_belongings
  scope :by_belongings, -> client_ids do
    by_recipients = where("invoices.recipient_ids @> ARRAY[?]", client_ids.map{|c| c.to_i}).ids

    project_ids = Project.by_clients(client_ids).ids
    by_projects = where("project_id IN (?)", project_ids)

    ids = by_recipients + by_projects

    where("invoices.id IN (?)", ids)
  end

  scope :valid, -> * { where("invoices.is_valid = ?", true) }

  # VALIDATIONS
  validates :project_id, :user_id, :recipient_ids, :status, :invoice_number, :subject, :due_date, :issue_date, presence: true
  validates :invoice_number, uniqueness: true

  before_create :set_valid

  def set_valid
    self.is_valid = true
  end

  def new_invoice_number
    invoices_this_month = Invoice.this_month
    if invoices_this_month.size == 0
      last_num = 0
    else
      last_num = Invoice.this_month.last.invoice_number[9..10].to_i
    end
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


  def tax_payment
    total = 0
    unless self.is_tax_included
      total = self.total_payment * self.tax.to_f / 100
    end

    total
  end

  def total_payment
    total = 0
    self.invoice_items.map { |e| total = total + (e.unit_price.to_i * e.quantity) }

    total
  end

  def grand_total_payment
    total = tax_payment + total_payment
  end

  def recipients
    users = User.where("id IN (?)", self.recipient_ids)
    users
  end

  def self.invoice_orders_chart_data_per_project_this_year(user_id)
    today = Date.today
    end_of_today = today.end_of_day

    orders = where(created_at: today.beginning_of_year..end_of_today).where(is_valid: true)

    unless user_id.nil?
      user = User.find(user_id)
      if user.client?
        project_ids = Project.by_clients([user_id]).ids

        orders = orders.where("project_id IN (?)", project_ids)
      end
    end

    orders = orders.group("project_id")
    orders = orders.select("project_id, count(*) as total_invoice")
    orders.group_by{|o| o.project_id}

    data = {}
    orders.each { |e| data[e.project_id.to_i] = e.total_invoice }

    data
  end

end
