
def sending_expect method, path, params, expectedResult
  sending_r_expect( new_ml_request( method, path, params ), expectedResult )
end

def sending_r_expect ml_req, expectedResult
  actual = app.handle ml_req
  hash_submatch actual, expectedResult
end

def new_ml_request method, path, params={}
  Ml_RackRequest.new  Rack::MockRequest.env_for( path, {:method => method, :params=>params} )
end


def hash_submatch( fatHash, thinHash )
  slice_per( fatHash, thinHash ).should == thinHash
end

# {:a=>1, :b=>2, :c=>3}.slice_per({:b=y, :c=>z}) returns {:b=>2, :c=>3}
def slice_per( fatHash, thinHash )
  thinHash.inject({}) { |slice, (k,v) | slice[k] = fatHash[k] ; slice }
end


def request_via_rack_adapter_without_server( app, method, path, params={} ) # app should be Muffinland_via_rack
  request = Rack::MockRequest.new(app)
  request.request(method, path, {:params=>params}) # sends the req through the Rack call(env) chain
end
