class ResourceType < ApplicationRecord
  has_many :collection_resource_type_joins, dependent: :destroy
  has_many :collections, through: :collection_resource_type_joins

  validates :name, presence: true
end