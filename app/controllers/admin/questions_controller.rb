class Admin::QuestionsController < Admin::ApplicationController
  before_filter :prepare_form_before
      
  def index
    page = params[:page].to_i if params[:page] and params[:page] =~ /^(\d)*/
    page ||= 0
    @questions = Question.page(page) 
  end  
  
  def new; end

  def create
    @question = Question.create(params[:question])
    flash.now[:error] = @question.errors.messages if @question.errors
    render 'new'
  end

  def edit; end

  def show; end
  
  def update
    @question = Question.find_by_id(params[:id])
    (Question::ANSWERNUM - @question.answers.size).times {
      @question.answers.build
    }
    @question.update_attributes!(params[:question])
    render 'edit'
  rescue Exception => e
    flash.now[:error] = e.message
    render 'edit'
  end

  protected
  def prepare_form_before
    params[:question][:level] = params[:question][:level].to_i if params[:question] && params[:question][:level]
    @tags = Tag.all.map{|t| [t.content, t.id]}
    @timerange = Question::TIMERANGE
    @question = Question.find_by_id(params[:id]) if params[:id]
    @question ||= Question.new
    (Question::ANSWERNUM - @question.answers.size).times {
      @question.answers.build
    }
  end
end
