class Admin::TagsController < Admin::ApplicationController
  def index
    @tags = Tag.all
  end

  def new
    @tag = Tag.new
  end

  def edit
    @tag = Tag.find_by_id(params[:id])
  end

  def create
    @tag = Tag.create(params[:tag])
    flash.now[:notice] = 'Success!'
    render 'edit'
  rescue Exception => e
    logger.error(e.backtrace.join '\n')
  end

  def update
    @tag = Tag.find_by_id(params[:id])
    raise Exception, 'invalid tag id' unless @tag
    @tag.update_attributes!(params[:tag])
    render 'edit'
  rescue Exception => e
    render status: 500
  end

  def delete
    tag = Tag.find_by_id(params[:tag_id])
    tag.delete
    redirect_to action: :index
  end
end
