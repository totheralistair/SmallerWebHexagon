# Here is how to go through Rackup
require './src/smaller_web_hexagon_via_rack'
require './src/raters'

run Smaller_web_hexagon_via_rack.new(
        Smaller_web_hexagon.new,"./src/views/" )


