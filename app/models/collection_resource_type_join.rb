class CollectionResourceTypeJoin < ApplicationRecord
  belongs_to :collection
  belongs_to :resource_type
end