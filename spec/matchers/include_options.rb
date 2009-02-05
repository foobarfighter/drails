module CustomMatchers
  class IncludeOptions
    def initialize(expected_options)
      @expected_options = expected_options
    end

    def matches?(actual_options)
      @actual_options = actual_options
      @actual_options.each do |k, v|
        if !@expected_options.has_key?(k)
          @message = "actual has a key that was not expected: #{k}"
          return false
        end
        if v != @expected_options[k]
          @message = "expected #{@expected_options[k]}, got #{v} for key: #{k}"
          return false
        end
      end
      @expected_options.each do |k, v|
        if !@actual_options.has_key?(k)
          @message = "actual is missing a key that was in expected: #{k}"
          return false
        end
      end

      true
    end

    def failure_message
      @message + "\n" +
      "ACTUAL:\n" +
      "=======\n" +
      @actual_options.inspect + "\n" +
      "\n" +
      "EXPECTED:\n" +
      "=========\n" +
      @expected_options.inspect + "\n"
    end

  end

  def include_options(expected_options)
    IncludeOptions.new(expected_options)
  end
end