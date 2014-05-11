require 'redcarpet'
require 'pygments'

class MarkdownRenderer
  class PygmentsHTML < Redcarpet::Render::HTML
    def block_code code, language
      Pygments.highlight code, lexer: language
    end
  end
    
  mattr_accessor :renderer
  
  def initialize
    html_render = PygmentsHTML.new(hard_wrap: true, filter_html: true)
    @renderer = Redcarpet::Markdown.new( html_render, autolink: true, fenced_code_blocks: true, space_after_headers: true )
  end

  def render(text)
    @renderer.render(text)
  end
end
