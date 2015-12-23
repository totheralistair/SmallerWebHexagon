require_relative '../src/smaller_web_hexagon'
require_relative '../src/rack_http_adapter'
require_relative '../src/raters'
require 'rack/test'
require 'rspec/expectations'
require 'test/unit'

# The first 2 tests check the primary adapter swaps, using direct API access for the left
# The last test checks the secondary adapter swap, using Rack input.
# The config.ru file runs the real server stuff, for the final usage test.

# note about the tests, I made all the raters give different answers,
# so that I can see if they are hooked up wrong


class TestRequests < Test::Unit::TestCase
  attr_accessor :app

  def test_it_works_with_in_code_rater
    p __method__

    @app = SmallerWebHexagon.new(InCodeRater.new)

    value_should_produce_rate 100, 1.01
    value_should_produce_rate 200, 1.5
  end


  def test_it_works_with_file_rater
    p __method__

    @app = SmallerWebHexagon.new(FileRater.new("file_rater.txt"))

    value_should_produce_rate 10, 1.00
    value_should_produce_rate 100, 2.0
  end


  def test_runs_via_rack_adapter
    p __method__

    viewsFolder = "../src/views/"
    hex = SmallerWebHexagon.new (InCodeRater.new)
    app = RackHttpAdapter.new(hex, viewsFolder)

    request = Rack::MockRequest.new(app)
    response = request.request("GET", '/100') # sends the req through the Rack call(env) chain

    out = {               # expected values
        out_action:   "result_view",
        value:  100,
        rate:   1.01,
        result: (100)*(1.01)
    }
    response.body.should == html_from_template_file(viewsFolder + "result_view.erb" , binding)
  end


  def value_should_produce_rate value, exp_rate
    rate, result = @app.rate_and_result value

    rate.should == exp_rate
    result.should == value * exp_rate
  end

end
