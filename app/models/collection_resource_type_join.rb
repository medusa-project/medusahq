class CollectionResourceTypeJoin < ApplicationRecord
  belongs_to :collection
  belongs_to :resource_type

  validates_presence_of :collection_id, :resource_type_id
  validates_uniqueness_of :resource_type_id, scope: :collection_id
end