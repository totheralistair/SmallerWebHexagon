# run the Smaller Web Hexagon from a browser

require './src/smaller_web_hexagon'
require './src/smaller_web_hexagon_via_rack'
require './src/raters'

hex = SmallerWebHexagon.new(InCodeRater.new)
app = SmallerWebHexagonViaRack.new(hex,"./src/views/")

run app


