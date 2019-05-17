class AddMedusaFields < ActiveRecord::Migration[5.2]
  def change
    add_column :collections, :contact_email, :string
    add_column :collections, :medusa_id, :integer, null: false
    add_index :collections, :medusa_id, unique: true
  end
end
