# Welcome to Smallerwebhexagon, the simple web hexagon implementation
# Alistair Cockburn and a couple of really nice friends

# this hexagon has one primary port and one secondary
# the user/test/web side is the primary
# the rates "database" mechanism is the secondary
# the app itself just returns value * rate(as a function of value)


class SmallerWebHexagon


  def initialize rater
    @rater = rater     # the database port needs configuring
  end

  def rate_and_result  value
    rate = @rater.rate(value)
    result = value * rate
    return rate, result
  end

end



