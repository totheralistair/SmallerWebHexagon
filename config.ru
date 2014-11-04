# Here is how to go through Rackup
require './src/smaller_webhexagon_via_rack'
require './src/persisters'

run Smaller_web_hexagon_via_rack.new(  Smaller_web_hexagon.new(Nul_persister.new),"./src/views/" )


