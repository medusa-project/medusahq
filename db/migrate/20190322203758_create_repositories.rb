class CreateRepositories < ActiveRecord::Migration[5.2]
  def change
    create_table :repositories do |t|
      t.string :uuid
      t.string :title
      t.string :url
      t.text :notes
      t.string :address_1
      t.string :address_2
      t.string :city
      t.string :state
      t.string :zip
      t.string :phone_number
      t.string :email
      t.string :contact_email
      t.string :ldap_admin_group
    end
    add_index :repositories, :uuid
  end
end
