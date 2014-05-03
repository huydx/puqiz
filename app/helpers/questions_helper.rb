module QuestionsHelper
  def tag_content(id)
    @tags ||= Tag.all.map {|t| [t.id, t.content]}
    ret = @tags.find {|t| t[1] == id}
    return ret[0] if ret
  end
end
