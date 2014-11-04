require_relative '../src/ml_request'
require_relative '../test/utilities_for_tests'

# A Persister hows how to persist posts

class Nul_persister
  def handle_new_post p
    # p p.yamld
  end
end


class File_persister
  def initialize fn
    @myFn = fn
    remove_file fn
  end

  def handle_new_post p
    File.open( @myFn, 'a') do |f| f << p.to_yaml end
  end
end
