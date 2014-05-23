module Admin::QuestionsHelper
  def slider_view(ticker_num, val)
    return view = <<-SLIDER
      <input type="text" class="slider" value="#{val}" data-slider-min="0" data-slider-max=#{ticker_num} data-slider-step="1" data-slider-orientation="horizontal" data-slider-tooltip="hide">
    SLIDER
  end

  def error_view(errors)
    view = ""
    return view unless errors.is_a? Hash
    errors.each do |k, v|
      view << <<-ERROR
        <span class="label label-warning">#{k.to_s} error: #{v.join(" and ")}</span><br/>
      ERROR
    end
    view << "<br/>"
  end

  def shorten(text, max_len)
    return text if text.length <= max_len
    return "#{text[0..max_len-1]}..."
  end

  def tag_content(id)
    @tags ||= Tag.all.map {|t| [t.id, t.content]}
    ret = @tags.find {|t| t[0] == id}
    return ret[1] if ret
  end

  def default_level(object)
    object.level.nil? ? 1 : object.level
  end
end
