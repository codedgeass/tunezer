class ProductionsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  
  def new
    @production = Production.new
    if params[:new_search]
      if params[:new_search].blank?
        @empty_search = true
      else
        @productions = Production.where('name ILIKE ?', "%#{params[:new_search]}%").page(params[:productions_page])
      end
    end
  end
  
  def create
    @production = Production.new
    @production.assign_attributes(production_params)
    if @production.valid?
      @production.number_of_votes = 0
      @production.save!
      redirect_to productions_path, notice: "Sucessfully created #{@production.name}"
    else
      render 'new'
    end
  end
  
  def index
    @klass = params[:klass] || 'Production'
    @category = params[:category] || 'All'
    @genre = params[:genre] || 'All'
    @index_search = params[:index_search]
    @productions_or_concerts = find_productions_or_concerts
    if request.xhr?
      if params[:productions_or_concerts_page]
        render 'display_page'
      elsif params[:index_search]
        render 'index_search'
      elsif params[:genre]
        render 'filter_genre'
      else
        render 'filter_category'
      end
    end
  end

  def show
    @production = Production.find(params[:id])
    @videos = @production.videos.page(1)
    @comment = Comment.new
    # `linked_comment` is passed from a notification in a user's profile page.
    @linked_comment = Comment.find(params[:linked_comment]) if params[:linked_comment]
    # These four params are passed from a redirection in their controllers that occurs when Javascript is disabled.
    @concerts = @production.concerts.best_rank.page(params[:concerts_page])
    @comments = @production.comments.page(params[:comments_page])
    @new_video = Video.new if params[:new_video?]
    @new_concert = Concert.new if params[:new_concert?]
    # `concert_id` is passed from a concert's link in the concert rankings on the productions/index page or
    #   from the show action in the concerts controller when Javascript is disabled.
    if params[:concert_id].present? 
      @concert = Concert.find(params[:concert_id])
      @rating = current_user.ratings.find_by(concert_id: params[:concert_id]) || Rating.new
    end
  end
  
  def destroy
    @production = Production.find(params[:id])
    @production.destroy
    @klass =  'Production'
    @category = params[:category] || 'All'
    @genre = params[:genre] || 'All'
    @index_search = params[:index_search]
    @productions_or_concerts = find_productions_or_concerts
  end
  
  private # ====================================================================================================
  
  def production_params
    params.require(:production).permit(:name, :genre, :category)
  end
  
  # These methods filter results in the index action. TODO: Move the methods to their own model.
  
  def find_productions_or_concerts
    @klass.constantize.where(conditions).best_rank.page(params[:productions_or_concerts_page])
  end
  
  def genre_conditions
    ['genre = ?', @genre] unless @genre == 'All'
  end
  
  def category_conditions
    ['category = ?', @category] unless @category == 'All'
  end
  
  def keyword_conditions
    ['name ILIKE ?', "%#{@index_search}%"] unless @index_search.blank?
  end
  
  def conditions
    [conditions_clauses.join(' AND '), *conditions_options]
  end
  
  def conditions_clauses
    conditions_parts.map { |condition| condition.first }
  end
  
  def conditions_options
    conditions_parts.map { |condition| condition[1..-1] }.flatten
  end
  
  def conditions_parts
    private_methods(false).grep(/_conditions$/) { |m| send(m) }.compact
  end
end