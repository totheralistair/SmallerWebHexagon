require 'erb'
require 'erubis'


def html_from_templatefile( template_full_fn, binding )
  page_template = Erubis::Eruby.new(File.open(template_full_fn, 'r').read)
  page_template.result(binding)
end
