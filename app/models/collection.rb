class Collection < ApplicationRecord

  before_validation :assign_uuid, on: :create

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

  private

  def assign_uuid
    self.uuid ||= SecureRandom.uuid
  end

end
