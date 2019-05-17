class CreateAccessSystems < ActiveRecord::Migration[5.2]
  def change
    create_table :access_systems do |t|
      t.string :name
      t.string :service_owner
      t.string :application_manager
    end
  end
end
