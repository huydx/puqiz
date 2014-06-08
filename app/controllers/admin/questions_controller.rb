#-*- encoding: utf-8 -*-
class Admin::QuestionsController < Admin::ApplicationController
  before_filter :prepare_edit_form_before, only: [:new, :create, :edit, :show, :update]
  before_filter :prepare_index_view_before, only: [:index, :delete]
  before_filter :merge_params_answer, only: [:update]
      
  def index
    tag_id = (params[:tag_id] || 0).to_i
    if tag_id > 0
      @questions = @questions.where(tag_id: tag_id)
    end
    @select_tag_id = tag_id
  end  
  
  def new; end

  def create
    @question = Question.create(params[:question]) do |q|
      q.html_content = $markdown.render(params[:question][:content])
    end
    flash.now[:error] = @question.errors.messages if @question.errors
    if flash.now[:error].empty?
      flash.now[:notice] = "Success!"
      render 'show' and return 
    else
      make_empty_answers
      render 'new' and return
    end
  rescue Exception => e
    logger.error(e.message)
    flash.now[:error] = "Error!" 
    make_empty_answers
    render 'new'
  end

  def edit; end

  def show; end
  
  def update
    @question = Question.find_by_id(params[:id])
    @question.update_attributes!(params[:question])
    flash.now[:error] = @question.errors.messages if @question.errors
    render 'edit'
  rescue Exception => e
    flash.now[:error] = e.message
    render 'edit'
  end

  def delete
    qid = (params[:question_id] || -1).to_i
    render 'index' and return unless qid > 0
    Question.delete(qid)
    render 'index'
  end

  protected
  def prepare_edit_form_before
    @tags = Tag.all.map{|t| [t.content, t.id]}
    @timerange = Question::TIMERANGE
    @question = Question.find_by_id(params[:id]) || Question.new
    make_empty_answers
  end

  def make_empty_answers
    (Question::ANSWERNUM - @question.answers.size).times {
      @question.answers.build
    }
  end
  
  def prepare_index_view_before
    page = params[:page].to_i
    @questions = Question.page(page) 
    @tags = Tag.all.map{|t| [t.content, t.id]}
    @tags.prepend ["全部", 0]
  end

  def merge_params_answer
    if answers = params[:question][:answers_attributes]
      answers.each do
        |key, val| val.merge!("flag" => "0") unless val["flag"] 
        if val["content"].blank?
          val.merge!(_destroy: true)
        end
      end
    end
  rescue Exception => e
  end
end
