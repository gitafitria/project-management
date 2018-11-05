json.array!(@clients) do |client|
  json.extract! client, :id, :first_name, :last_name, :role, :email
end