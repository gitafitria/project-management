json.extract! invoice_item, :id, :description, :quantity, :unit_price, :invoice_id, :is_valid, :created_at, :updated_at
json.url invoice_item_url(invoice_item, format: :json)
