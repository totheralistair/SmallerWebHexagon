require 'rack'
require 'yaml'


def yaml_my requests
  out = Array.new
  requests.each {|req| out << req.to_yaml }
  out
end

def requests_from_yaml_stream(stream)
  requests = YAML::load_documents( stream ) { |req|
    req.clean_from_yaml
  }
end





class Ml_RackRequest
# a Rack::Request wrapper
# Warning about Rack::Request, it has two semi-undocumented strange things
# 1. three fields are StringIO, which do not serialize.
#    I have to turn them into strings temporarily to serialize,
#    and recreate them on loading from serializing
# 2. "params" modifies the request, adding the @params inst var
#    i.e. reading the params changes the request
#    This may only matter for testing or serialization.
#    but it is an undocumented side effect of reading params, so watch out.

  #note: this pile of accessors looks too complicated to me. Waiting for a simplification

  def initialize( env )
    @myRequest = Rack::Request.new( env )
    @myRequest.params # calling params has "side effect" of changing the Request! :(.
    # better to do it now and save later surprises :-(
  end

  def self.from_yaml yamld_request
    real_request = YAML::load StringIO.new( yamld_request )
    real_request.env["rack.input"] = StringIO.new(  real_request.env["rack.input"]  )
    real_request.env["rack.errors"] = StringIO.new(  real_request.env["rack.errors"]  )

    if real_request.env["rack.request.form_input"]
      real_request.env["rack.request.form_input"] = StringIO.new(  real_request.env["rack.request.form_input"]  )
    end
    real_request
  end

  def to_yaml
    rack_input = @myRequest.env["rack.input"]
    rack_errors = @myRequest.env["rack.errors"]
    form_input = @myRequest.env["rack.request.form_input"]

    @myRequest.env["rack.input"] = rack_input.string if rack_input.class == StringIO
    @myRequest.env["rack.errors"] = rack_errors.string if rack_errors.class == StringIO
    @myRequest.env["rack.request.form_input"] = form_input.string if form_input.class == StringIO

    out = YAML::dump(self)

    @myRequest.env["rack.input"] = rack_input
    @myRequest.env["rack.errors"] = rack_errors
    @myRequest.env["rack.request.form_input"] = form_input
    out
  end

  def clean_from_yaml # cleans up the Stringio fields inside Rack::Request
    Ml_RackRequest::from_yaml( self.to_yaml)
  end


  def env
    @myRequest.env
  end


  def get?; @myRequest.get? ;  end
  def post?; @myRequest.post? || thePath=="/post"            ; end
  def add?;  theParams.has_key?("Add")    ; end

  def command
    case
      when add?       then :add
        else nil
    end
  end

  def theParams ; @myRequest.params ;  end
  def thePath ;  @myRequest.path ; end

  def name_from_path ;  thePath[ 1..thePath.size ] ;  end
  def id_from_path ;  id_from_name( name_from_path )     ;  end
  def id_from_name( name ) ;  number_or_nil(name) ;  end
  def number_or_nil( s ) # convert string to a number, nil if not a number
    i= s.to_i
    i.to_s == s ? i : nil
  end

  def incoming_muffin_name;  theParams["MuffinNumber"]   ;  end
  def incoming_muffin_id; n = incoming_muffin_name ; id_from_name( n ) ;  end
  def incoming_contents; theParams["MuffinContents"] ;  end

end

