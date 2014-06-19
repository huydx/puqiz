#-*- encoding: utf-8 -*-
class Admin::QuestionReviewsController < Admin::ApplicationController
  before_filter :prepare_edit_form, only: [:edit, :update]

  def index #[TODO] too dirty, need reafactoring
    page = params[:page].to_i
    tag_id = params[:tag_id].to_i
    level = params[:level].to_i

    @questions = QuestionReview.page(page)
    @questions = @questions.where(tag_id: tag_id) if tag_id > 0
    @questions = @questions.where(level: level) if level > 0
    @select_tag_id = tag_id    
    @select_level = level

    @tags = Tag.all.map { |t| [t.content, t.id] } 
    @tags.prepend ["全部", 0]

    @levels = *(1..Question::LEVELNUM)
    @levels.prepend ["全部", 0]
  end

  def edit
    @question = QuestionReview.find_by_id(params[:id].to_i)
  end

  def create; end

  def update
    modify_params_to_save
    question = Question.create(params[:question])
    @question = QuestionReview.find_by_id(params[:id])
    @question.delete if @question
    raise Exception, question.errors.join('\n') unless question.errors.empty?
    redirect_to action: :index
  rescue Exception => e
    flash.now[:error] = e.message
    raise ActiveRecord::Rollback, 'some error occur!'
  rescue ActiveRecord::Rollback
    render 'edit'
  end

  def verify; end

  def delete
    QuestionReview.find_by_id(params[:question_review_id]).delete
    redirect_to admin_question_reviews_path
  rescue Exception => e
    binding.pry
    render text: "error!"
  end
  
  def search

  end

  protected
  def modify_params_to_save
    params[:question] = params.delete :question_review
    params[:question][:answers_attributes] = params[:question].delete :answer_reviews_attributes

    params[:question].delete :id
    params[:question][:answers_attributes].each { |k,v| params[:question][:answers_attributes][k].delete :id}
  end

  def prepare_edit_form
    @tags = Tag.all.map { |t| [t.content, t.id] }
    @timerange = Question::TIMERANGE
  end
end
