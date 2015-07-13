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
    @concerts = find_concerts
    @gmaps_markers = Gmaps4rails.build_markers(@concerts) do |concert, marker|
      marker.lat concert.latitude
      marker.lng concert.longitude
      marker.infowindow render_to_string( partial: 'info_window_link', locals: { concert: concert } )
    end
    if request.xhr?
      if params[:concerts_page]
        render 'display_page'
      elsif params[:term]
        concerts = Concert.where('name ILIKE ?', "#{params[:term]}%").limit(10)
        render json: concerts.map {|concert| { label: concert.name, value: "concerts/#{concert.id}" } }
      else # params[:genre]
        headers['Content-Type'] = 'text/javascript; charset=utf-8' # workaround for a bug in `render_to_string`
        render 'filter_genre'
      end
    end
  end

  def show
    @concert = Concert.includes(:city, :state, :country).find(params[:id])
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
    @concerts = find_concerts
  end
  
  private # ====================================================================================================
  
  def concert_params
    params.require(:concert).permit(:name, :genre)
  end
  
  # Used in `index` and `destroy`.
  
  def find_concerts
    if @genre == 'All'
      Concert.includes(:genre, :venue, :city, :state, :country).best_rank.page(params[:concerts_page])
    else
      Concert.joins(:genre).where(genres: { name: params[:genre] } ).
        preload(:genre, :venue, :city, :state, :country).best_rank.page(params[:concerts_page])
    end
  end
end