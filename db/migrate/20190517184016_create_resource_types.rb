class CreateResourceTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :resource_types do |t|
      t.string :name
    end
  end
end
