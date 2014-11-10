# Welcome to Smallerwebhexagon, the simple web hexagon implementation
# Alistair Cockburn and a couple of really nice friends

#require_relative '../src/utilities_for_smaller_hexagon'

class Smaller_web_hexagon
# this hexagon has one left port and one right
# the user/test/web side is the left
# the rates "database" mechanism is the right
# the app itself just returns value * rate(as a function of value)


  def initialize
    @rater = Nul_rater.new # the right-hand port needs configuring
  end

# this is the "configurable dependency" part...
  def use_rater rater    # right side of the hexagon
    @rater = rater
  end


# invoke 'handle(request)' directly from your test code or from a web adapter.

  def handle( request )

    value =  path_as_number(request)
    rate = @rater.rate( value )
    result = value * @rater.rate( value )

    out = {
        out_action:   "result_view",
        value:  value,
        rate:   rate,
        result: result
    }

  end

end

# ==== utilities for reading a Rack Request ====

def path_as_number( request ) ;  number_or_zero( path_contents(request) )  ;  end

def path_contents( request );  request.path[ 1..request.path.size ] ;  end

def number_or_zero( s ) # convert string to a number, zero if not a number
  i= s.to_i
  i.to_s == s ? i : 0
end




