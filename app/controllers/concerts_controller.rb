class ConcertsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  
  def new
    @concert = Concert.new
    if params[:new_search]
      if params[:new_search].blank?
        @empty_search = true
      else
        @concerts = Concert.where('name ILIKE ?', "%#{params[:new_search]}%").page(params[:concerts_page])
      end
    end
  end
  
  def create
    @concert = Concert.new
    @concert.assign_attributes(concert_params)
    if @concert.valid?
      @concert.number_of_votes = 0
      @concert.save!
      redirect_to concerts_path, notice: "Sucessfully created #{@concert.name}"
    else
      render 'new'
    end
  end
  
  def index
    @genre = params[:genre] || 'All'
    @index_search = params[:term]
    @concerts = find_concerts
    if request.xhr?
      if params[:concerts_page]
        render 'display_page'
      elsif params[:term]
        concerts = Concert.where('name ILIKE ?', "%#{@index_search}%").limit(10)
        render json: concerts.map {|concert| { label: concert.name, value: "concerts/#{concert.id}" } }
      else # params[:genre]
        render 'filter_genre'
      end
    end
  end

  def show
    @concert = Concert.find(params[:id])
    @videos = @concert.videos.page(1)
    @comment = Comment.new
    # `linked_comment` is passed from a notification in a user's profile page.
    @linked_comment = Comment.find(params[:linked_comment]) if params[:linked_comment]
    # The next three params are passed during a redirection that occurs when Javascript is disabled.
    @comments = @concert.comments.page(params[:comments_page])
    @new_video = Video.new if params[:new_video?]
    @rating = current_user.ratings.find_by(concert_id: params[:id]) || Rating.new if user_signed_in?
  end
  
  def destroy
    @concert = Concert.find(params[:id])
    @concert.destroy
    @genre = params[:genre] || 'All'
    @index_search = params[:index_search]
    @concerts = find_concerts
  end
  
  private # ====================================================================================================
  
  def concert_params
    params.require(:concert).permit(:name, :genre)
  end
  
  # These methods filter results in the index action. TODO: Move the methods to their own model.
  
  def find_concerts
    Concert.where(conditions).best_rank.page(params[:concerts_page]).per_page(10)
  end
  
  def genre_conditions
    ['genre = ?', @genre] unless @genre == 'All'
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