module ApplicationHelper
  def safe_tag_image(source, options={})
    default_source = 'default_tag_image.jpeg'
    raise Exception if source.nil? || source.url.nil?
    image_tag(source, options)
  rescue Exception => e
    image_tag(default_source, options)
  end
end
