class VirtualRepository < ApplicationRecord

  belongs_to :repository
  has_many :collection_virtual_repository_joins, dependent: :destroy
  has_many :collections, through: :collection_virtual_repository_joins
  validates_presence_of :title

end