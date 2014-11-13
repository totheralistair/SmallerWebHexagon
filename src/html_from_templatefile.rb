require 'erb'
require 'erubis'

def html_from_templatefile(templateFullFn, binding)
  pageTemplate = Erubis::Eruby.new(File.open(templateFullFn, 'r').read)
  pageTemplate.result(binding)
end
