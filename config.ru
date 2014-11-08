# Here is how to go through Rackup
require './src/smaller_web_hexagon_via_rack'
require './src/raters'

hex = Smaller_web_hexagon.new
hex.use_rater In_code_rater.new

app = Smaller_web_hexagon_via_rack.new( hex,"./src/views/" )

run app


