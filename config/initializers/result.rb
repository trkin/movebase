class Result
  attr_accessor :message, :data

  # Example of returning results, for example in service:
  #   return Result.new 'Next task created', next_task: next_task
  # and use in controller:
  #   if result.success? && result.data[:next_task] == task
  def initialize(message, data = {})
    @message = message
    @data = OpenStruct.new data
  end

  def success?
    true
  end
end

class Error < Result
  def success?
    false
  end
end
