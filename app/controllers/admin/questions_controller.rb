class Admin::QuestionsController < Admin::ApplicationController
  def new
    @question ||= Question.new
    @tags = Tag.all.map{|t| [t.content, t.id]}
    @timerange = Question::TIMERANGE
    4.times { @question.answers.build }
  end

  def create
    params[:question][:level] = params[:question][:level].to_i if params[:question] && params[:question][:level]
    @question = Question.create(params[:question])
    redirect_to new_admin_question_path
  end
end
