class AttachmentsController < ArticlesController
  skip_before_filter :require_login, only: [:show, :inline, :minify_img]
  before_action :set_article, only: [:create, :show, :edit, :update, :destroy, :minify_img, :inline]
  before_action :set_attachment, only: [:show, :edit, :update, :destroy, :minify_img, :inline]

  # GET /attachments/1
  # GET /attachments/1.json
  def show
    send_data @attachment.data, :filename => @attachment.title, :type => @attachment.mime_type, :disposition => "inline"
  end
  
  def inline
    send_data @attachment.data, :filename => @attachment.title, :type => @attachment.mime_type, :disposition => "inline"
  end
  
  def edit
    @attachments = Attachment.select(:id, :title).order(:title).load
  end

  # POST /attachments
  # POST /attachments.json
  def create      
    if attachment_params[:file].nil?
      flash[:error] = "There was a problem submitting your attachment."
      redirect_to :back
    else
      @attachment = @article.attachments.new
      @attachment.uploaded_file = attachment_params
      if @attachment.save
	@article.update_attributes(updated_at: Time.now)
	flash[:notice] = "Thank you for your submission..."
	redirect_to :back
      else
	flash[:error] = "There was a problem submitting your attachment."
	redirect_to :back
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
      @attachment = @article.attachments.find(params[:id])
    end
        
    def set_article
      @article = Article.find(params[:article_id])
    end
    # Never trust parameters from the scary internet, only allow the white list through.
    def attachment_params
      params.require(:attachment).permit(:file)
    end
    
    def attachments_params
      params.permit(:mime_type)
    end
end
