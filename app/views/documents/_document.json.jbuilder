json.extract! document, :id, :document_name, :project_id, :user_id, :is_valid, :created_at, :updated_at
json.url document_url(document, format: :json)
