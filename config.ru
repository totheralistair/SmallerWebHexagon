# run the Smaller Web Hexagon from a browser

require './src/smaller_web_hexagon_via_rack'
require './src/raters'

hex = SmallerWebHexagon.new  In_code_rater.new
app = SmallerWebHexagonViaRack.new  hex,"./src/views/"

run app


