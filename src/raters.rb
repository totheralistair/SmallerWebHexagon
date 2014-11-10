# a Rater produces a multiplier ("rate") given a value
# here are three kinds of raters:
#  - simply a constant (the default one)
#  - a variable in-code one that can be used when the db is down
#  - one w the table stored in a file (or db, but I only know files so far)
# note: I'm making them all give different rates, so that mistakes show up easier


class Nul_rater
  def rate value
    1.1    # the nul rater just returns a constant
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
    @rates = []
    File.open(fn) do |f|
      f.each_line do |line|
        @rates << line.split.map(&:to_f)
      end
    end
  end

  def rate value # ugly code but I only need to know it works
    case
      when value >= @rates[0][0] && value < @rates[1][0]
        rate = @rates[0][1]
      when value >= @rates[0][0]
        rate = @rates[1][1]
    end
  end

end

