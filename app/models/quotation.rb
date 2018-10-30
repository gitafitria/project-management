class Quotation < ApplicationRecord
  belongs_to :project, optional: true
  belongs_to :user, optional: true

  # by_projects
  scope :by_projects, -> by_projects { where("quotations.project_id in (?)", by_projects) }
  # by_creators
  scope :by_creators, -> by_creators { where("quotations.user_id in (?)", by_creators) }

  # VALIDATIONS
  validates :content, :project_id, :user_id, presence: true

  def self.projects_list
    Project.where("id IN (?)", Invoice.all.collect(&:project_id).uniq)
  end

end
