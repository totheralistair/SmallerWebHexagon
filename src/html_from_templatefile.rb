
require 'erb'
require 'erubis'


def htmlpage_from_templatefile( templateFullFn, binding ) # where does this really belong?
  pageTemplate = Erubis::Eruby.new(File.open( templateFullFn, 'r').read)
  pageTemplate.result(binding)
end


