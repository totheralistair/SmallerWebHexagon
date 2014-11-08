require_relative '../test/utilities_for_tests'
require_relative '../src/html_from_templatefile'



class TestRequests < Test::Unit::TestCase
  attr_accessor :app


  def test_runs_via_Rack_adapter # just check hexagon integrity, not a data check
    p __method__

    viewsFolder = "../src/views/"
    app = Smaller_web_hexagon.new_w_driver(
        Smaller_web_hexagon_via_rack, viewsFolder
    )

    hex_out = {
        out_action:   "result_view",
        value:  100,
        rate:   1.1,
        result: (100)*(1.1)
    }

    response = request_via_rack_adapter_without_server( app, "GET", '/100')
    response.body.should == htmlpage_from_templatefile( viewsFolder + "result_view.erb" , binding )
  end


  def test_00_hardcoded_result_works
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



  def test_02_requests_serialize_and_reconstitute_back_and_forth
    p __method__

    r0 = new_ml_request('POST', '/ignored',{ "Add"=>"Add", "MuffinContents"=>"apple" })
    r0.to_yaml.should == Ml_RackRequest::from_yaml( r0.to_yaml ).to_yaml
  end



  def test_03_can_reload_history_from_array_and_continue
    p __method__

    @app = Smaller_web_hexagon.new( Nul_persister.new )

    r0 = new_ml_request('POST', '/ignored',{ "Add"=>"Add", "MuffinContents"=>"apple" })
    app.dangerously_restart_with_history [ r0 ]

    r1 = new_ml_request('POST', '/ignored',{ "Add"=>"Add", "MuffinContents"=>"banaba" })
    app.handle r1

    app.dangerously_all_posts.should == [ r0, r1 ]
  end




  def test_04_can_run_history_to_from_strings_and_files
    p __method__

    @app = Smaller_web_hexagon.new( Nul_persister.new )

    # 1st, fake a history in a file:
    r0 = new_ml_request('POST', '/ignored',{ "Add"=>"Add", "MuffinContents"=>"less chickens" })
    array_out_to_file( [ r0.to_yaml ], history_in_file='mlhistory.txt' )

    # see if that reads OK:
    requests = requests_from_yaml_stream2( File.open( history_in_file) )
    app.dangerously_restart_with_history requests
    sending_expect "GET", '/0', {},
                   {
                       out_action:   "GET_named_page",
                       muffin_id:   0,
                       muffin_body: "less chickens"
                   }

    # then add to the history in the ordinary way
    sending_expect 'POST', '/ignored',{ "Add"=>"Add", "MuffinContents"=>"more chickens" } ,
                     {
                         out_action:   "GET_named_page",
                         muffin_id:   1,
                         muffin_body: "more chickens"
                     }

    yamld_history = yaml_my app.dangerously_all_posts     # notice I didn't check it yet. lazy

    # finally, add to the history using faked-up string / StringIO, see if that works:
    r2 = new_ml_request('POST', '/ignored',{ "Add"=>"Add", "MuffinContents"=>"end of chickens" })
    history_in_string = array_out_to_string ( yamld_history << r2.to_yaml )

    requests = requests_from_yaml_stream2( StringIO.new( history_in_string) )
    app.dangerously_restart_with_history requests

    sending_expect "GET", '/1', {},
                   {
                       out_action:   "GET_named_page",
                       muffin_id:   1,
                       muffin_body: "more chickens"
                   }

    sending_expect "GET", '/2', {},
                   {
                       out_action:   "GET_named_page",
                       muffin_id:   2,
                       muffin_body: "end of chickens"
                   }

    sending_expect "GET", '/3', {},
                   {
                       out_action:   "404"
                   }
    # if that all works, loading/unloading/faking history w arrays/strings/files all work :-)
  end

end


