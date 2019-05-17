class Collection < ApplicationRecord

  before_validation :assign_uuid, on: :create
  before_create :ensure_medusa_id

  validates_format_of :uuid,
                      with: StringUtils::UUID_REGEX,
                      message: 'UUID is invalid'
  validates_presence_of :title
  #TODO optional: true is merely to make the existing tests pass - we'll probably want to remove it later
  belongs_to :repository, primary_key: :uuid, foreign_key: :repository_uuid, optional: true
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
    self.medusa_id ||= self.class.max(:medusa_id) + 1
  end

  private

  def assign_uuid
    self.uuid ||= SecureRandom.uuid
  end

end
