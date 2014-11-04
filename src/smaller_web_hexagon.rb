# Welcome to Smallerwebhexagon, the simple web hexagon implementation
# Alistair Cockburn and a couple of really nice friends

require_relative '../src/ml_responses' # the API output defined for Smallerwebhexagon


class Smaller_web_hexagon
# Smallerwebhexagon knows global policies and environment, not histories and private things.

  def initialize persister
    @thePersister = persister
  end


# primary port of Hexagon: takes value, returns result = value * rate
# invoke 'handle(request)' directly from your test code or (eg Rack) web handler.
# input: any class that supports the Ml_request interface
# output: a hash with all the data produced for consumption

  def handle( request ) # note: all 'handle's return 'ml_response' in a chain
    value = request.name_from_path=="" ? 0 : request.id_from_path
    rate = 1.1 #hardcode for now 10% cuz it's easy
    result = value * rate

    out = {
        out_action:   "result_view",
        value:  value,
        rate:   rate,
        result: result
    }
  end


end

