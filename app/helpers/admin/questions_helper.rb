module Admin::QuestionsHelper
  def slider_view(ticker_num, val)
    return view = <<-SLIDER
      <input type="text" class="slider" value="#{val}" data-slider-min="0" data-slider-max=#{ticker_num} data-slider-step="1" data-slider-orientation="horizontal" data-slider-tooltip="hide">
    SLIDER
  end

  def error_view(errors)
    view = ""
    if errors.is_a? Hash
      errors.each do |k, v|
        view << <<-ERROR
          <span class="label label-warning">#{k.to_s} error: #{v.join(" and ")}</span><br/>
        ERROR
      end
      view << "<br/>"
    elsif errors.is_a? String  
      view = "<span class='label label-warning'>error: #{errors}</span><br/>"
    end
    view
  end

  def shorten(text, max_len)
    return text if text.length <= max_len
    return "#{text[0..max_len-1]}..."
  end

  def tag_content(id)
    @tags_map ||= Tag.all.map {|t| {id: t.id, content: t.content}}
    ret = @tags_map.find {|t| t[:id] == id }
    return ret[:content] if ret
  end

  def default_level(object)
    object.level.nil? ? 1 : object.level
  end
end
