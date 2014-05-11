require 'redcarpet'
require 'pygments'

class MarkdownRenderer
  attr_accessor :markdown

  class HTMLwithPygments < Redcarpet::Render::HTML
    def block_code(code, language)
      Pygments.highlight(code, lexer: language.to_sym, options: {
        encoding: 'utf-8'
      })
  end
end
 
  def initialize
    @markdown = Redcarpet::Markdown.new(HTMLwithPygments,
      :fenced_code_blocks => true,
      :no_intra_emphasis => true,
      :autolink => true,
      :strikethrough => true,
      :lax_html_blocks => true,
      :superscript => true,
      :hard_wrap => false,
      :tables => true,
      :xhtml => false)
  end

  def render(text) 
    text.gsub!(/\{\{( *)?"(.*?)"\}\}/, '\1\2')
    text.gsub!(/^\{% highlight (.+?) ?%\}(.*?)^\{% endhighlight %\}/m) do |match|
      Pygments.highlight($2, :lexer => $1, :options => {:encoding => 'utf-8'})
    end
   
    @markdown.render(text)
  end 
end
