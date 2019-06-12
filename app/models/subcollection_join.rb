class SubcollectionJoin < ApplicationRecord

  belongs_to :parent_collection, class_name: 'Collection'
  belongs_to :child_collection, class_name: 'Collection'

  validates_presence_of :parent_collection_id
  validates_presence_of :child_collection_id
  validates_uniqueness_of :child_collection_id, scope: :parent_collection_id

  validates_each :child_collection_id do |record, attr, value|
    #this is a little bit funny to get the tests to pass for uniqueness validation. I don't think there is harm,
    # since another validation will pick up the case where one of the repositories is not present
    child_repository = record.child_collection.try(:repository)
    parent_repository = record.parent_collection.try(:repository)
    record.errors.add attr, 'Collection cannot be a child collection of itself' if value == record.parent_collection_id
    record.errors.add attr, 'Parent and child collection must be in the same repository' unless child_repository.present? and parent_repository.present? and child_repository == parent_repository
  end

end