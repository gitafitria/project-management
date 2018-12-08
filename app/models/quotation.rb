class Quotation < ApplicationRecord
  belongs_to :project, optional: true
  belongs_to :user, optional: true

  # by_projects
  scope :by_projects, -> by_projects { where("quotations.project_id in (?)", by_projects) }
  # by_creators
  scope :by_creators, -> by_creators { where("quotations.user_id in (?)", by_creators) }
  # by_belongings
  scope :by_belongings, -> user_ids do
    by_creators = where("quotations.user_id in (?)", user_ids).ids

    project_ids = Project.by_clients(user_ids).ids
    by_projects = where("project_id IN (?)", project_ids)

    ids = by_creators + by_projects

    where("quotations.id IN (?)", ids)
  end

  scope :valid, -> * { where("quotations.is_valid = ?", true) }

  # VALIDATIONS
  validates :content, :title, presence: true
  validates :project_id, presence: true, if: Proc.new{|e| e.user_id.present? }
  validates :email, presence: true, if: Proc.new{|e| e.user_id.nil? }

  before_create :set_valid

  def set_valid
    self.is_valid = true
  end

  def self.projects_list
    Project.where("id IN (?)", Invoice.all.collect(&:project_id).uniq)
  end

end
