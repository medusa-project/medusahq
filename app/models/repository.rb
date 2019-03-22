class Repository < ApplicationRecord

  before_validation :assign_uuid, on: :create

  validates_format_of :uuid,
                      with: StringUtils::UUID_REGEX,
                      message: 'UUID is invalid'
  validates_presence_of :title
  has_many :collections, primary_key: :uuid, foreign_key: :repository_uuid

  def to_param
    uuid
  end

  private

  def assign_uuid
    self.uuid ||= SecureRandom.uuid
  end

end