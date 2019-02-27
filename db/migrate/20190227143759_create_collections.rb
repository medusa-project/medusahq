class CreateCollections < ActiveRecord::Migration[5.2]
  def change
    create_table :collections do |t|
      t.string :repository_id, null: false
      t.string :title, null: false
      t.text :description
      t.text :description_html
      t.string :access_url
      t.string :external_id
      t.boolean :published, default: false, null: false
      t.boolean :ongoing, default: true, null: false
      t.string :representative_image_id, limit: 40
      t.string :representative_item_id, limit: 40
      t.boolean :harvestable, default: false, null: false
      t.string :contentdm_alias
      t.text :notes

      t.timestamps
    end

    add_index :collections, :repository_id, unique: true
    add_index :collections, :title, unique: true
    add_index :collections, :external_id
    add_index :collections, :published
    add_index :collections, :ongoing
    add_index :collections, :harvestable
    add_index :collections, :contentdm_alias, unique: true
  end
end
