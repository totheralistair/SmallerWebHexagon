require 'rack/test'
require 'rspec/expectations'
require 'test/unit'
require 'erubis'
require_relative '../src/smaller_web_hexagon.rb'
require_relative '../src/smaller_web_hexagon_via_rack.rb'
require_relative '../src/persisters'
require_relative '../test/utilities_for_tests'


def new_ml_request method, path, params={}
  Ml_RackRequest.new  Rack::MockRequest.env_for( path, {:method => method, :params=>params} )
end

def sending_expect method, path, params, expectedResult
  sending_r_expect( new_ml_request( method, path, params ), expectedResult )
end

def sending_r_expect ml_req, expectedResult
  actual = app.handle ml_req
  hash_submatch actual, expectedResult
end


def hash_submatch( fatHash, thinHash )
  slice_per( fatHash, thinHash ).should == thinHash
end

# {:a=>1, :b=>2, :c=>3}.slice_per({:b=y, :c=>z}) returns {:b=>2, :c=>3}
def slice_per( fatHash, thinHash )
  thinHash.inject({}) { |slice, (k,v) | slice[k] = fatHash[k] ; slice }
end






def remove_file  fn
  FileUtils.rm( fn ) if File.file?( fn )
end

def array_out_to_file( array_of_stuff, fn )
  remove_file  fn
  # FileUtils.rm( fn ) if File.file?( fn )
  File.open( fn, 'w') do |f|
    array_of_stuff.each {|y| f<<y}
  end
end

def array_out_to_string( array_of_yamlds )
  array_of_yamlds.inject("") {|out, y| out << y}
end


def requests_from_yaml_stream2( stream )
  requests = requests_from_yaml_stream(stream)
  requests.each {|r| r.clean_from_yaml }
end










def request_via_rack_adapter_without_server( app, method, path, params={} ) # app should be Muffinland_via_rack
  request = Rack::MockRequest.new(app)
  request.request(method, path, {:params=>params}) # sends the req through the Rack call(env) chain
end

def page_from_template( fn, binding )
  pageTemplate = Erubis::Eruby.new(File.open( fn, 'r').read)
  pageTemplate.result(binding)
end


def hex_wire_up(hex, left, right, left_param)
  hex_app = hex.new( right.new )
  left.new( hex_app, left_param )
end