#-*- encoding: utf-8 -*-
class Admin::QuestionsController < Admin::ApplicationController
  before_filter :prepare_edit_form_before, only: [:new, :create, :edit, :show, :update]
  before_filter :prepare_index_view_before, only: [:index, :delete, :search]
  before_filter :merge_params_answer, only: [:update]
      
  def index
    tag_id = (params[:tag_id] || 0).to_i
    level  = (params[:level] || 0).to_i
    if tag_id > 0
      @questions = @questions.where(tag_id: tag_id)
    end

    if level > 0
      @questions = @questions.where(level: level)
    end

    @select_tag_id = tag_id
    @select_level = level.to_i
  end  
  
  def new
    @previous_selected_tag = params[:previous_tag_id]
  end

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

  def search
    keywords = params[:question].fetch(:keyword)
    keywords = keywords.split()
    like_sql_with_keywords =
      keywords.map { |k| "content LIKE '%#{k}%'" }.join(" OR ")
    @questions = Question.where(like_sql_with_keywords)
    render 'index'
  end

  def generate_csv
    require 'csv'
    questions = Question.all
    
    data = CSV.generate do |csv|
      csv << ["内容","タグ","レベル","時間","参照","内容html","説明","説明html","回答"]
      questions.each do |question|
        csv << [
          question.content,
          tag_content(question.tag_id),
          question.level,
          question.time,
          question.url,
          question.html_content,
          question.explaination || "",
          question.explaination_html_content || "",
          question.answers.to_yaml,
        ]
      end
    end

    send_data(
      data,
      type: 'text/csv',
      filename: "question_backup_#{Time.now.strftime('%Y_%m_%d_%H_%M_%S')}.csv"
    )
  end

  def batch_import
    require 'csv'
    order = [:content, :tag_name, :level, :time, :url, :html_content, :explaination, :explaination_html_content, :answers]
    csv = CSV.open(params[:uploaded_file][:file].tempfile, 'r')
    csv.each_with_index do |row, index|
      next if index == 0
      Question.create do |question|
        row.each_with_index do |field, index|
          key = order[index]
          case key
          when :content, :level, :time, :url, :explaination
            question.send("#{key.to_s}=", field)
          when :tag_name
            question.tag_id = Tag.find_by_content(field).id
          when :answers
            answers = YAML.load(field) 
            answers.each { |ans| 
              question.answers << Answer.create(
                content: ans.content, flag: ans.flag)
            }
          end
        end
      end
    end
    
    redirect_to admin_questions_path
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
    @levels = *(1..Question::LEVELNUM)
    @levels.prepend ["全部", 0]
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

  def tag_content(id)
    @tags ||= Tag.all
    @tags.find {|t| t.id == id}.content
  end
end
