class AttachmentsController < ApplicationController
  skip_before_filter :authenticate_user!, only: [:show, :inline, :minify_img]
  skip_before_filter :current_user, only: [:inline, :minify_img]
  skip_before_filter :set_permissions, only: [:inline, :minify_img]
  skip_before_filter :set_menus, only: [:inline, :minify_img]
  skip_before_filter :profile_empty?, only: [:inline, :minify_img]
  skip_before_filter :set_alert, only: [:inline, :minify_img]
  skip_before_filter :set_details, only: [:inline, :minify_img]  
  before_action :set_attachment, only: [:show, :edit, :update, :destroy, :minify_img, :inline]
  before_action :require_administrator, only: [:index]
  before_action :require_writer, only: [:edit, :create, :update, :destroy]

  # GET /attachments
  # GET /attachments.json
  def index
    @mime_types = Attachment.select(:mime_type).all.map{|a| a.mime_type}.uniq
    @attachments = Attachment.where(attachments_params).paginate(:page => params[:page])
  end

  # GET /attachments/1
  # GET /attachments/1.json
  def show
    send_data @attachment.data, :filename => @attachment.title, :type => @attachment.mime_type, :disposition => "inline"
  end
  
  def inline
    send_data @attachment.data, :filename => @attachment.title, :type => @attachment.mime_type, :disposition => "inline"
  end
  
  def edit
    @article = Article.select(:id).find(params[:article_id])
    @attachments = Attachment.select(:id, :title).order(:title).load
  end

  # POST /attachments
  # POST /attachments.json
  def create      
    if attachment_params[:id].blank? && attachment_params[:file].nil?
      flash[:error] = "There was a problem submitting your attachment."
      redirect_to :back
    else
      unless attachment_params[:id].blank?
	@attachment = Attachment.find(attachment_params[:id])
	case 
	  when params[:article_id]
	    article = Article.find(params[:article_id])
	    @attachment.articles << article
	    article.update_attributes(published: false) unless current_user_moderator?
	    article.update_attributes(updated_at: Time.now)
	  when params[:division_id]
	    @attachment.divisions << Division.find(params[:division_id])
	end
	flash[:notice] = "Thank you for your submission..."
	redirect_to :back
      else
	@attachment = Attachment.new
	@attachment.uploaded_file = attachment_params
	if @attachment.save
	  params[:article_id]
	  article = Article.find(params[:article_id])
	  @attachment.articles << article
	  article.update_attributes(published: false) unless current_user_moderator?
	  article.update_attributes(updated_at: Time.now)
	  flash[:notice] = "Thank you for your submission..."
	  redirect_to :back
	else
	    flash[:error] = "There was a problem submitting your attachment."
	    redirect_to :back
	end
      end
    end
  end

  def update
    @attachment = Attachment.find(attachment_params[:id])
    @old_attachment = Attachment.find(params[:id])
    if attachment_params[:id].blank? && attachment_params[:file].nil?
      flash[:error] = "There was a problem submitting your attachment."
      redirect_to :back
    else
      unless attachment_params[:file]
	if @attachment == @old_attachment
	  flash[:error] = "Attachments are identical."
	  redirect_to :back
	else
	  article = Article.find(params[:article_id])
	  @attachment.articles << article
	  article.update_attributes(published: false) unless current_user_moderator?
	  article.update_attributes(updated_at: Time.now)
	  if (@old_attachment.articles.count + @old_attachment.divisions.count + @old_attachment.profiles.count) > 1 && params[:article_id]
	    article = Article.find(params[:article_id])
	    @old_attachment.articles.delete(article) if article
	  else
	    @old_attachment.destroy
	  end
	  flash[:notice] = "Thank you for your submission..."
	  redirect_to article
	end
      else
	@attachment = Attachment.find(params[:id])
	@attachment.uploaded_file = attachment_params
	if @attachment.save
	  params[:article_id]
	  article = Article.find(params[:article_id])
	  article.update_attributes(published: false) unless current_user_moderator?
	  article.update_attributes(updated_at: Time.now)
	  flash[:notice] = "Thank you for your submission..."
	  redirect_to article
	else
	  flash[:error] = "There was a problem submitting your attachment."
	  redirect_to :back
	end
      end
    end
  end
  
  # DELETE /attachments/1
  # DELETE /attachments/1.json
  def destroy
    if (@attachment.articles.count + @attachment.divisions.count + @attachment.profiles.count) > 1 && params[:article_id]
      article = Article.find(params[:article_id])
      @attachment.articles.delete(article) if article
      redirect_to :back
    else
      @attachment.destroy
      respond_to do |format|
	format.html { redirect_to :back }
	format.json { head :no_content }
      end
    end
  end

  def minify_img()
    send_data @attachment.thumbnail, :filename => @attachment.title, :type => @attachment.mime_type, :disposition => "inline"
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_attachment
      @attachment = Attachment.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def attachment_params
      params.require(:attachment).permit(:id, :file)
    end
    
    def attachments_params
      params.permit(:mime_type)
    end
end
