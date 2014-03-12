class CommentsController < ArticlesController
  before_action :require_login, only: [:new, :destroy, :published_toggle]
  before_action :set_article, only: [:index, :show, :edit, :create, :update, :destroy, :published_toggle]
  before_action :set_comment, only: [:show, :edit, :update, :destroy, :published_toggle]
  def index
    @comments = @article.comments.all
  end
  
  def show
  end
  
  def new
    @comment = @article.comments.new
  end
  
  def create
    @comment = @article.comments.new(comment_params)
    @comments = current_user.nil? ? @article.comments.where(published: true) : @article.comments
    respond_to do |format|
      if @comment.save
        format.html { redirect_to :back, notice: 'Comment was successfully created.' }
	format.js
      else
        format.html { render action: "new" }
      end
    end
  end
  
  def update
    if @comment.update(comment_params)
      redirect_to @comment, notice: 'Comment was successfully updated.'
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @comment.destroy
    @comments = @article.comments
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end
  
  def published_toggle
    @comment.toggle!(:published)
    redirect_to :back
  end
  
  private
  def set_article
    @article = Article.find(params[:article_id])
  end
  
  def set_comment
    @comment = @article.comments.find(params[:id])
  end
  
  def comment_params
    params.require(:comment).permit(:article_id, :content)
  end
end
