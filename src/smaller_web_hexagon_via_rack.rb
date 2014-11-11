require 'rack'
require_relative '../src/smaller_web_hexagon'
require_relative '../src/html_from_templatefile'


# Hex adapter to Smallerwebhexagon using Rack for web-type I/O

class SmallerWebHexagonViaRack

  def initialize( hex_app, viewsFolder )
    @app = hex_app
    @viewsFolder = viewsFolder
  end


  def call(env) # hooks into the Rack Request chain

    request = Rack::Request.new( env )
    value =  path_as_number(request)

    rate, result = @app.rate_and_result  value

    out = {
        out_action:   "result_view",
        value:  value,
        rate:   rate,
        result: result
    }

    template_fn = @viewsFolder + out[:out_action] + ".erb"
    page = html_from_templatefile( template_fn , binding )

    response = Rack::Response.new
    response.write( page )
    response.finish
  end


end

# ==== utilities for reading a Rack Request ====

def path_as_number( request ) ;  number_or_zero( path_contents(request) )  ;  end

def path_contents( request );  request.path[ 1..request.path.size ] ;  end

def number_or_zero( s ) # convert string to a number, zero if not a number
  i= s.to_i
  i.to_s == s ? i : 0
end


