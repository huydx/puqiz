module ApplicationHelper
  def safe_tag_image(source, options={})
    default_source = 'no_image.jpg'
    raise Exception if source.nil? || source.url.nil?
    image_tag(source, options)
  rescue Exception => e
    image_tag(default_source, options)
  end

  def tag_content(id)
    Tag.find(id).content
  end

  def degree_content(num)
    case num
    when 1; "Beginner";
    when 2; "Intermediate";
    when 3; "Senior";
    when 4; "Master";
    when 5; "Legendary";
    end
  end

  def tag_of(question_id)
    tag_id = Question.find_by_id(question_id).tag_id
    return Tag.find_by_id(tag_id)
  end

  def tag_content_of(question_id)
    tag_of(question_id).content
  end
end
