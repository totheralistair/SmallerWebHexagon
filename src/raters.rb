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
    File.open( @myFn, 'r') do |f| f end
    @rates = [ [100, 1.0], [200, 2.0]]
  end

  def rate value
    @rates.each do | break_and_rate, index |
      if value <  break_and_rate[0] do
        out = break_and_rate[1]
        return
      end
end

    end
  end

end
