class CreateVirtualRepositories < ActiveRecord::Migration[5.2]
  def change
    create_table :virtual_repositories do |t|
      t.references :repository, foreign_key: true
      t.string :title
    end
  end
end
