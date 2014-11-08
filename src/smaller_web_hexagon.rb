# Welcome to Smallerwebhexagon, the simple web hexagon implementation
# Alistair Cockburn and a couple of really nice friends

class Smaller_web_hexagon
# this hexagon has one left port and one right
# the user/test/web side is the left, needs a param ViewsFolder to work (ugh)
# the rates "database" mechanism is the right, needs no params
# the app itself just multiplies input * rate(as a function of rate), outputs it

  def self.new_w_driver( user_adapter, viewsFolder )
    # left side of hexagon
    hex = self.new
    app = Smaller_web_hexagon_via_rack.new( hex, viewsFolder )
  end


  def initialize
    @rater = Nul_rater.new
  end

  def use_rater rater
    # this is the right side of the hexagon
    @rater = rater
  end

# invoke 'handle(request)' directly from your test code or (eg Rack) web handler.

  def handle( request ) # note: all 'handle's return 'ml_response' in a chain
    value = request.name_from_path=="" ? 0 : request.id_from_path
    rate = 1.1 #hardcode for now 10% cuz it's easy
    result = value * @rater.rate( value )

    out = {
        out_action:   "result_view",
        value:  value,
        rate:   rate,
        result: result
    }
  end

end

