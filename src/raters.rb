require_relative '../src/ml_request'
require_relative '../test/utilities_for_tests'

# A Persister hows how to persist posts

class Nul_rater
  def rate value
    1.1    # the nul rater just returns the constant
  end
end

class In_code_rater
  def rate value
    case
      when value <= 100
        1.01
      when value > 100
        1.5
    end
  end
end


# class File_persister
#   def initialize fn
#     @myFn = fn
#     remove_file fn
#   end
#
#   def handle_new_post p
#     File.open( @myFn, 'a') do |f| f << p.to_yaml end
#   end
# end
