# Welcome to Smallerwebhexagon, the simple web hexagon implementation
# Alistair Cockburn and a couple of really nice friends

class Smaller_web_hexagon
# this hexagon has one left port and one right
# the user/test/web side is the left
# the rates "database" mechanism is the right
# the app itself just returns value * rate(as a function of value)


  def initialize
    @rater = Nul_rater.new
  end

# this is the "configurable dependency" part...
  def use_rater rater    # right side of the hexagon
    @rater = rater
  end


# invoke 'handle(request)' directly from your test code or from a web adapter.

  def handle( request )

    value = request.path_contents == "" ?
        0 :
        request.id_from_path
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

