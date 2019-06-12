class AccessSystemCollectionJoin < ApplicationRecord
  belongs_to :access_system
  belongs_to :collection

  validates_presence_of(:collection_id, :access_system_id)
  validates_uniqueness_of :access_system_id, scope: :collection_id
end