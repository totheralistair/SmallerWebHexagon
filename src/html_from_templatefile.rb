require 'erb'
require 'erubis'


def html_from_templatefile( template_path, binding )
  page_template = Erubis::Eruby.new(File.open(template_path, 'r').read)
  page_template.result(binding)
end
