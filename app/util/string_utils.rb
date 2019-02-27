class StringUtils

  UUID_REGEX = /\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/

  ##
  # @param start_time [Time]
  # @param index [Integer]
  # @param count [Integer]
  # @param message [String]
  # @return [void]
  #
  def self.print_progress(start_time, index, count, message)
    str = "#{message}: #{StringUtils.progress(start_time, index, count)}"
    print "#{str.ljust(80)}\r"
  end

  private

  ##
  # @param start_time [Time]
  # @param index [Integer]
  # @param count [Integer]
  # @return [String] Progress string containing percent complete and ETA.
  #
  def self.progress(start_time, index, count)
    pct = index / count.to_f
    eta = TimeUtils.eta(start_time, pct).localtime.strftime('%-m/%d %l:%M %p')
    "#{(pct * 100).round(2)}% [ETA: #{eta}]"
  end

end
