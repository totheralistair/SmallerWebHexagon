# run the Smaller Web Hexagon from a browser

require './src/smaller_web_hexagon'
require './src/rack_http_adapter'
require './src/raters'

hex = SmallerWebHexagon.new  InCodeRater.new
app = RackHttpAdapter.new hex, './src/views/'

run app
