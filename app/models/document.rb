class Document < ApplicationRecord
  mount_uploader :doc_file, DocUploader

  belongs_to :project
  # by_projects
  scope :by_projects, -> by_projects { where("documents.project_id in (?)", by_projects) }
  # by_creators
  scope :by_creators, -> by_creators { where("documents.user_id in (?)", by_creators) }

  def self.projects_list
    Project.where("id IN (?)", Invoice.all.collect(&:project_id).uniq)
  end

end
