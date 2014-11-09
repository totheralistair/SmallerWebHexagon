require_relative '../test/utilities_for_tests'
require_relative '../src/html_from_templatefile'



class TestRequests < Test::Unit::TestCase
  attr_accessor :app


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


  def test_00_works_w_no_rater
    p __method__

    @app = Smaller_web_hexagon.new
    sending_expect "GET", '/100', {} ,
                   {
                       out_action:   "result_view",
                       value:  100,
                       rate:   1.1,
                       result: (100)*(1.1)
                   }
  end



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




  def test_03_works_from_file_rater
    p __method__

    @app = Smaller_web_hexagon.new( Nul_rater.new )
    broken here

  end

  #
  #
  # def test_04_can_run_history_to_from_strings_and_files
  #   p __method__
  #
  #   @app = Smaller_web_hexagon.new( Nul_rater.new )
  #
  #   # 1st, fake a history in a file:
  #   r0 = new_ml_request('POST', '/ignored',{ "Add"=>"Add", "MuffinContents"=>"less chickens" })
  #   array_out_to_file( [ r0.to_yaml ], history_in_file='file_rater.txt' )
  #
  #   # see if that reads OK:
  #   requests = requests_from_yaml_stream2( File.open( history_in_file) )
  #   app.dangerously_restart_with_history requests
  #   sending_expect "GET", '/0', {},
  #                  {
  #                      out_action:   "GET_named_page",
  #                      muffin_id:   0,
  #                      muffin_body: "less chickens"
  #                  }
  #
  #   # then add to the history in the ordinary way
  #   sending_expect 'POST', '/ignored',{ "Add"=>"Add", "MuffinContents"=>"more chickens" } ,
  #                    {
  #                        out_action:   "GET_named_page",
  #                        muffin_id:   1,
  #                        muffin_body: "more chickens"
  #                    }
  #
  #   yamld_history = yaml_my app.dangerously_all_posts     # notice I didn't check it yet. lazy
  #
  #   # finally, add to the history using faked-up string / StringIO, see if that works:
  #   r2 = new_ml_request('POST', '/ignored',{ "Add"=>"Add", "MuffinContents"=>"end of chickens" })
  #   history_in_string = array_out_to_string ( yamld_history << r2.to_yaml )
  #
  #   requests = requests_from_yaml_stream2( StringIO.new( history_in_string) )
  #   app.dangerously_restart_with_history requests
  #
  #   sending_expect "GET", '/1', {},
  #                  {
  #                      out_action:   "GET_named_page",
  #                      muffin_id:   1,
  #                      muffin_body: "more chickens"
  #                  }
  #
  #   sending_expect "GET", '/2', {},
  #                  {
  #                      out_action:   "GET_named_page",
  #                      muffin_id:   2,
  #                      muffin_body: "end of chickens"
  #                  }
  #
  #   sending_expect "GET", '/3', {},
  #                  {
  #                      out_action:   "404"
  #                  }
  #   # if that all works, loading/unloading/faking history w arrays/strings/files all work :-)
  # end

end


