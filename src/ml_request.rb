require 'rack'

class Ml_RackRequest
# a Rack::Request wrapper

  def initialize( env )
    @myRequest = Rack::Request.new( env )
    @myRequest.params # calling params has "side effect" of changing the Request! :(.
    # better to do it now and save later surprises :-(
  end

  def thePath ;  @myRequest.path ; end
  def path_contents;  thePath[ 1..thePath.size ] ;  end
  def id_from_path ;  number_or_nil( path_contents )     ;  end


  def number_or_nil( s ) # convert string to a number, nil if not a number
    i= s.to_i
    i.to_s == s ? i : nil
  end

end

