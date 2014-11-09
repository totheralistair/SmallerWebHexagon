require_relative '../src/ml_request'
require_relative '../test/utilities_for_tests'

# A Persister hows how to persist posts

class Nul_rater
  def rate value
    1.1    # the nul rater just returns the constant
  end
end

class In_code_rater
  def rate value
    case
      when value <= 100
        1.01
      when value > 100
        1.5
    end
  end
end


class File_rater

  def initialize fn
    @myFn = fn
    @rates = []
    File.open(fn) do |f|
      f.each_line do |line|
        @rates << line.split.map(&:to_f)
      end
    end
  end

  def rate value
    case
      when value >= @rates[0][0] && value < @rates[1][0]
        rate = @rates[0][1]
      when value >= 100
        rate = @rates[1][1]
    end
  end

end

