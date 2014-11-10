require 'rack'
require_relative '../src/smaller_web_hexagon'
require_relative '../src/html_from_templatefile'


# Hex adapter to Smallerwebhexagon using Rack for web-type I/O

class Smaller_web_hexagon_via_rack

  def initialize( hex_app, viewsFolder )
    @app = hex_app
    @viewsFolder = viewsFolder
  end


  def call(env) # hooks into the Rack Request chain
    p env
    request = Rack::Request.new( env )
    hex_out = @app.handle( request )   # call the hexagonal API directly, get struct back

    template_fn = @viewsFolder + hex_out[:out_action] + ".erb"
    page = html_from_templatefile( template_fn , binding )

    response = Rack::Response.new
    response.write( page )
    response.finish
  end

end

