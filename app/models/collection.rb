class Collection < ApplicationRecord

  before_validation :assign_repository_id, on: :create

  validates_format_of :repository_id,
                      with: StringUtils::UUID_REGEX,
                      message: 'UUID is invalid'
  validates_presence_of :title

  def to_param
    self.repository_id
  end

  def to_s
    self.repository_id
  end

  private

  def assign_repository_id
    self.repository_id ||= SecureRandom.uuid
  end

end
