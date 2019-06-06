class Collection < ApplicationRecord

  before_validation :assign_uuid, on: :create
  before_validation :ensure_medusa_id, on: :create
  before_save :nullify_blank_contentdm_alias

  validates_format_of :uuid,
                      with: StringUtils::UUID_REGEX,
                      message: 'UUID is invalid'
  validates_presence_of :title
  belongs_to :repository, primary_key: :uuid, foreign_key: :repository_uuid
  has_many :access_system_collection_joins, dependent: :destroy
  has_many :access_systems, -> {order(:name)}, through: :access_system_collection_joins
  has_many :collection_resource_type_joins, dependent: :destroy
  has_many :resource_types, through: :collection_resource_type_joins

  has_many :child_collection_joins, class_name: 'SubcollectionJoin', foreign_key: :parent_collection_id, dependent: :destroy
  has_many :child_collections, -> { order('title ASC') }, through: :child_collection_joins
  has_many :parent_collection_joins, class_name: 'SubcollectionJoin', foreign_key: :child_collection_id, dependent: :destroy
  has_many :parent_collections, -> { order('title ASC') }, through: :parent_collection_joins

  delegate :title, to: :repository, prefix: true

  def to_param
    self.uuid
  end

  def to_s
    self.uuid
  end

  #TODO - this should be done database side with a sequence, but that should probably wait until the
  # final data migration is done so that the sequence can be started correctly.
  # In practice, it's unlikely that doing this is going to create a problem, though.
  # Note that the 'medusa_id' field on import corresponds to the collection registry database id of the collection,
  # which is used in keying the objects in storage. So when collections start to get created here we'll want to use
  # that same concept to do that, and of course we need to preserve those ids to connect to existing data.
  def ensure_medusa_id
    self.medusa_id ||= (self.class.maximum(:medusa_id) || 0) + 1
  end

  def peer_collections
    repository.collections.order(:title).where.not(id: id)
  end

  private

  def assign_uuid
    self.uuid ||= SecureRandom.uuid
  end

  #This is necessary because of the unique index on contentdb_alias, i.e. we need a NULL value there rather than
  # just a blank string.
  def nullify_blank_contentdm_alias
    self.contentdm_alias = nil if contentdm_alias.blank?
  end

end
