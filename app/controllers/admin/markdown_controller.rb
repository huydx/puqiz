class Admin::MarkdownController < Admin::ApplicationController
  def rendering
    text = params["text"] || ""
    render text: $markdown.render(text)
  end
end
