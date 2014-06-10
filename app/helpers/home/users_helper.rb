module Home::UsersHelper
  def correct_percentage(tag_id)
    @correct_percentage= QuestionResult.correct_percentage(current_user.id, tag_id)
  end
end
