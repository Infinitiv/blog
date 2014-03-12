class ArticlesController < ApplicationController
  skip_before_filter :require_login, only: [:index, :show, :feed]
  before_action :set_article, only: [:show, :edit, :update, :destroy, :published_toggle, :up]

  # GET /articles
  # GET /articles.json
  def index
      @articles = current_user.nil? ? Article.includes(:attachments).order('updated_at DESC').where(published: true).paginate(:page => params[:page]) : Article.includes(:attachments).order('updated_at DESC').paginate(:page => params[:page])
  end

  # GET /articles/1
  # GET /articles/1.json
  def show
    unless current_user.nil?
      @attachment = Attachment.new
      @attachments = Attachment.select(:id, :title).order(:title).load
    end
    @first_image_attachment = @article.attachments.select {|a| a.mime_type =~ /image/}.first
    @image_attachments = (@article.attachments.select {|a| a.mime_type =~ /image/}.count > 1 ? @article.attachments.select {|a| a.mime_type =~ /image/} : [])
    @not_image_attachments = @article.attachments.select {|a| a.mime_type !~ /image/}
    @comment = @article.comments.new
    @comments = current_user.nil? ? @article.comments.where.not(id: nil).where(published: true) : @article.comments.where.not(id: nil)
  end

  # GET /articles/new
  def new
    @article = Article.new
  end

  # GET /articles/1/edit
  def edit 
  end

  # POST /articles
  # POST /articles.json
  def create
    @article = Article.new(article_params)
    respond_to do |format|
      if @article.save
        format.html { redirect_to @article, notice: 'Article was successfully created.' }
        format.json { render action: 'show', status: :created, location: @article }
      else
        format.html { render action: 'new' }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /articles/1
  # PATCH/PUT /articles/1.json
  def update
    respond_to do |format|
      if @article.update(article_params)
        format.html { redirect_to @article, notice: 'Article was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @article.errors, status: :unprocessable_entity }
      end
    end
  end
   
  # DELETE /articles/1
  # DELETE /articles/1.json
  def destroy
    @article.destroy
    respond_to do |format|
      format.html { redirect_to articles_url }
      format.json { head :no_content }
    end
  end
  
  def published_toggle
    @article.toggle!(:published)
    redirect_to :back
  end
  
  def up
    @article.update_attributes(updated_at: Time.now)
    redirect_to :back
  end

  def feed
    @articles = Article.order('updated_at DESC').where(published: true).where("updated_at > ?", Time.now.to_date - 30)
    
    respond_to do |format|
      format.atom
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_article
      @article = Article.includes(:attachments).find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def article_params
      params.require(:article).permit(:title, :content, :published)
    end
end
