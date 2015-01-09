class ConcertsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  
  def new
    @production = Production.find(params[:production_id])
    @concert = Concert.new
    respond_to do |format|
      format.html { redirect_to production_path(id: params[:production_id], new_concert?: true) }
      format.js
    end
  end

  def create
    @production = Production.find(params[:production_id])
    @concert = @production.concerts.build
    @concert.name = params[:concert][:name]
    if @concert.valid?
      @concert.genre = @production.genre
      @concert.category = @production.category
      @concert.number_of_votes = 0
      @concert.save!
      @concerts = @production.concerts.best_rank.page(1)
      @concerts = @concerts.page(@concerts.total_pages)
      respond_to do |format|
        format.html { redirect_to @production }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to @production, message: 'concert creation failed' }
        format.js { render 'new' }
      end
    end    
  end
  
  def index
    @production = Production.find(params[:production_id])
    @concerts = @production.concerts.best_rank.page(params[:concerts_page])
    respond_to do |format|
      format.html { redirect_to production_path(id: @production.id, concerts_page: params[:concerts_page]) }
      format.js
    end
  end
  
  def show
    @production = Production.find(params[:production_id])
    @concert = Concert.find(params[:id])
    if user_signed_in?
      @rating = current_user.ratings.find_by(concert_id: @concert.id) || Rating.new
      @concerts_page = params[:concerts_page]
    end
    respond_to do |format|
      format.html { redirect_to production_path(id: @production.id, concert_id: @concert.id) }
      format.js
    end
  end
  
  def destroy
    @concert = Concert.find(params[:id])
    @concert.destroy
    @production = Production.find(params[:production_id])
    @concerts = @production.concerts.best_rank.page(1)
  end
end