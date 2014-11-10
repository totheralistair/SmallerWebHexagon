require_relative '../src/smaller_web_hexagon_via_rack.rb'
require_relative '../src/raters'
require 'rack/test'
require 'rspec/expectations'
require 'test/unit'

# The first 3 tests check the right-side adapter swaps, using direct API access for the left
# The last test checks the left-side adapter swap, using Rack input.
# The config.ru file runs the real server stuff, for the final usage test.

# note about the tests, I made all the raters give different answers,
# so that I can see if they are hooked up wrong


class TestRequests < Test::Unit::TestCase
  attr_accessor :app

  def test_00_works_w_no_rater
    p __method__

    @app = Smaller_web_hexagon.new

    value_should_produce_rate 100, 1.1
  end



  def test_01_works_w_in_code_rater
    p __method__

    @app = Smaller_web_hexagon.new
    @app.use_rater In_code_rater.new

    value_should_produce_rate 100, 1.01
    value_should_produce_rate 200, 1.5
  end




  def test_03_works_from_file_rater
    p __method__

    @app = Smaller_web_hexagon.new
    @app.use_rater File_rater.new( fn = "file_rater.txt" )

    value_should_produce_rate 10, 1.00
    value_should_produce_rate 100, 2.0
  end




  def test_runs_via_Rack_adapter
    p __method__

    viewsFolder = "../src/views/"
    hex = Smaller_web_hexagon.new
    app = Smaller_web_hexagon_via_rack.new( hex,"../src/views/" )

    request = Rack::MockRequest.new(app)
    response = request.request("GET", '/100') # sends the req through the Rack call(env) chain

    hex_out = {
        out_action:   "result_view",
        value:  100,
        rate:   1.1,
        result: (100)*(1.1)
    }
    response.body.should == html_from_templatefile( viewsFolder + "result_view.erb" , binding )
  end


  #===== that's all folks, nothing more to see, move along now =====
end


# ===== some test utilities =====

def value_should_produce_rate value, rate

  actual = send_and_get "GET", "/#{value}", {}

  expectedResult = {
      out_action:   "result_view",
      value:  value,
      rate:   rate,
      result: (value)*(rate)
  }
  slice_per( actual, expectedResult ).should == expectedResult
end




def send_and_get method, path, params
  request = Rack::Request.new(
      Rack::MockRequest.env_for( path, {:method => method, :params=>params} )
  )
  app.handle request
end




# hash matching: {:a=>1, :b=>2, :c=>3}.slice_per({:b=y, :c=>z}) returns {:b=>2, :c=>3}
def slice_per( fatHash, thinHash )
  thinHash.inject({}) { |slice, (k,v) | slice[k] = fatHash[k] ; slice }
end

