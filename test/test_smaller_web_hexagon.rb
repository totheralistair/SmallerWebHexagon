require_relative '../test/utilities_for_tests'
require_relative '../src/html_from_templatefile'
require_relative '../src/smaller_web_hexagon_via_rack.rb'
require_relative '../src/raters'
require 'rack/test'
require 'rspec/expectations'
require 'test/unit'

# The first 3 tests check the right-side adapter swaps, using direct API access for the left
# The last test checks the left-side adapter swap, using Rack input.
# The config.ru file runs the real server stuff, for the final usage test.


class TestRequests < Test::Unit::TestCase
  attr_accessor :app

  #================================
  def test_00_works_w_no_rater
    p __method__

    @app = Smaller_web_hexagon.new

    value, rate = 100, 1.1
    sending_expect "GET", "/#{value}", {} ,
                   {
                       out_action:   "result_view",
                       value:  value,
                       rate:   rate,
                       result: (value)*(rate)
                   }
  end



  #================================
  def test_01_works_w_in_code_rater
    p __method__

    @app = Smaller_web_hexagon.new
    @app.use_rater In_code_rater.new

    value, rate = 100, 1.01
    sending_expect "GET", "/#{value}", {} ,
                   {
                       out_action:   "result_view",
                       value:  value,
                       rate:   rate,
                       result: (value)*(rate)
                   }

    value, rate = 200, 1.5
    sending_expect "GET", "/#{value}", {} ,
                   {
                       out_action:   "result_view",
                       value:  value,
                       rate:   rate,
                       result: (value)*(rate)
                   }
  end




  #================================
  def test_03_works_from_file_rater
    p __method__

    @app = Smaller_web_hexagon.new
    @app.use_rater File_rater.new( fn = "file_rater.txt" )

    value, rate = 10, 1.00
    sending_expect "GET", "/#{value}", {} ,
                   {
                       out_action:   "result_view",
                       value:  value,
                       rate:   rate,
                       result: (value)*(rate)
                   }

    value, rate = 100, 2.0
    sending_expect "GET", "/#{value}", {} ,
                   {
                       out_action:   "result_view",
                       value:  value,
                       rate:   rate,
                       result: (value)*(rate)
                   }

  end

  #================================
  def test_runs_via_Rack_adapter # just check hexagon integrity w Rack
    p __method__

    viewsFolder = "../src/views/"
    hex = Smaller_web_hexagon.new
    app = Smaller_web_hexagon_via_rack.new( hex,"../src/views/" )


    hex_out = {
        out_action:   "result_view",
        value:  100,
        rate:   1.1,
        result: (100)*(1.1)
    }

    response = request_via_rack_adapter_without_server( app, "GET", '/100')
    response.body.should == html_from_templatefile( viewsFolder + "result_view.erb" , binding )
  end



  #===== that's all folks, nothing more to see, move along now =====

end


