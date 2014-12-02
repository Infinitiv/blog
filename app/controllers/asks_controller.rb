class AsksController < ApplicationController
  skip_before_filter :require_login, only: [:index, :create]
  before_action :set_ask, only: [:show, :edit, :update, :destroy]
  before_action :set_asks, only: [:index, :create, :destroy]
  def index
  end
  
  def show
    
  end
  
  def new
    @ask = Ask.new
  end
  
  def create
    @ask = Ask.new(ask_params)
    @asks = current_user.nil? ? Ask.order(:created_at).where.not(answer: "").limit(20).reverse : Ask.order(:created_at).limit(20).reverse
    respond_to do |format|
      if @ask.save
        format.html { redirect_to :back, notice: 'Question was successfully created.' }
	format.js
      else
        format.html { render action: "new" }
      end
    end
  end
  
  def update
    if @ask.update(ask_params)
      redirect_to root_path, notice: 'Question was successfully updated.'
    else
      render action: 'edit'
    end
  end
  
  def destroy
    @ask.destroy
    @asks = current_user.nil? ? Ask.order(:created_at).where.not(answer: "").limit(20).reverse : Ask.order(:created_at).limit(20).reverse
    respond_to do |format|
      format.html { redirect_to :back }
      format.js
    end
  end
  
  private
  
  def set_ask
    @ask = Ask.find(params[:id])
  end
  
  def ask_params
    params.require(:ask).permit(:question, :answer)
  end
  
  def set_asks
    @asks = Ask.order(:created_at).load    
  end
end