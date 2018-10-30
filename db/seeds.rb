# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
connection = ActiveRecord::Base.connection();

User.create!(id: 1, email: "gita.fitria.gita@gmail.com", password: "$2a$10$s5HFsKe3EESu2iuE7SAEiu7okodLvMxyDLp9eLcMzXQecR/r2xkYC", password_confirmation: "$2a$10$s5HFsKe3EESu2iuE7SAEiu7okodLvMxyDLp9eLcMzXQecR/r2xkYC", reset_password_token: nil, reset_password_sent_at: nil, sign_in_count: 1, last_sign_in_at: "2015-09-15 10:49:37 UTC", created_at: "2014-05-19 10:21:21 UTC", updated_at: "2015-09-15 11:10:51 UTC", first_name: "Gita", last_name: "Ratnasari", role: "owner")
connection.execute("ALTER SEQUENCE users_id_seq RESTART WITH 2;")
