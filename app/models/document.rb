class Document < ApplicationRecord
  mount_uploader :doc_file, DocUploader

  belongs_to :project
  belongs_to :user
  # by_projects
  scope :by_projects, -> by_projects { where("documents.project_id in (?)", by_projects) }
  # by_creators
  scope :by_creators, -> by_creators { where("documents.user_id in (?)", by_creators) }
  # by_belongings
  scope :by_belongings, -> user_ids do
    by_creators = where("documents.user_id in (?)", user_ids).ids

    project_ids = Project.by_clients(user_ids).ids
    by_projects = where("project_id IN (?)", project_ids)

    ids = by_creators + by_projects

    where("documents.id IN (?)", ids)
  end

  validates :document_name, :project_id, :user_id, :doc_file, presence: true

  scope :valid, -> * { where("documents.is_valid = ?", true) }

  before_create :set_valid

  def set_valid
    self.is_valid = true
  end

  def self.projects_list
    Project.where("id IN (?)", Invoice.all.collect(&:project_id).uniq)
  end

end
