module Admin::QuestionsHelper
  def slider_view(ticker_num)
    return view = <<-SLIDER
      <input type="text" class="slider" value="" data-slider-min="0" data-slider-max=#{ticker_num} data-slider-step="1" data-slider-orientation="horizontal" data-slider-tooltip="hide">
    SLIDER
  end
end
