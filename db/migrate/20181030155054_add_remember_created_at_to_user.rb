class AddRememberCreatedAtToUser < ActiveRecord::Migration[5.2]
  def change
    # t.datetime :remember_created_at
    add_column :users, :remember_created_at, :datetime
  end
end
