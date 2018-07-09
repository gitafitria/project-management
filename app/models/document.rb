class Document < ApplicationRecord
  mount_uploader :doc_file, DocUploader

  belongs_to :project
end
