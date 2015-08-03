class ConcertsController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  
  def new
    @concert = Concert.new
  end
  
  def create
    venue    = Venue.create name: params[:concert][:venue]
    city     = City.create name: params[:concert][:city]
    state    = State.create name: params[:concert][:state]
    country  = Country.create name: params[:concert][:country]
    genre    = Genre.find_by(name: params[:concert][:genre])
    
    @concert = Concert.new
    @concert.venue_id = venue.id
    @concert.city_id = city.id
    @concert.state_id = state.id
    @concert.country_id = country.id
    @concert.genre_id = genre.id
    
    @concert.assign_attributes(concert_params)
    if @concert.valid?
      @concert.votes = 0
      @concert.save!
      redirect_to @concert
    else
      render 'new'
    end
  end
  
  def index
    @genre = params[:genre] || 'All'
    @gmaps_markers = Gmaps4rails.build_markers(Concert.all) do |concert, marker|
      marker.lat concert.latitude
      marker.lng concert.longitude
      marker.infowindow render_to_string( partial: 'info_window_link', locals: { concert: concert } )
    end
    @concerts = find_concerts
    if request.xhr?
      if params[:term] # TODO: Change to `:search`
        concerts = Concert.where('name ILIKE ?', "#{params[:term]}%").limit(10)
        render json: concerts.map {|concert| { label: concert.name, value: "#{concert.id}" } }
      elsif params[:concerts_page] || params[:sort] # && params[:size]
        render 'refresh_rankings'
      else # params[:genre]
        headers['Content-Type'] = 'text/javascript; charset=utf-8' # workaround for a bug in `render_to_string`
        render 'filter_genre'
      end
    end
  end

  def show
    @concert = Concert.includes(:city, :state, :country, :venue).find(params[:id])
    @gmaps_marker = Gmaps4rails.build_markers(@concert) do |concert, marker|
      marker.lat concert.latitude
      marker.lng concert.longitude
      marker.infowindow render_to_string( partial: 'info_window_link', locals: { concert: concert } )
    end
    @videos = @concert.videos.page(1)
    @comment = Comment.new
    # `linked_comment` is passed from a notification in a user's profile page.
    @linked_comment = Comment.find(params[:linked_comment]) if params[:linked_comment]
    @comments = @concert.comments.limit(10)
    @comments_count = @concert.comments.count
    @comments_offset = 1
    @rating = current_user.ratings.find_by(concert_id: params[:id]) || Rating.new if user_signed_in?
  end
  
  def destroy
    @concert = Concert.find(params[:id])
    @concert.destroy!
    @genre = params[:genre] || 'All'
    @concerts = find_concerts
  end
  
  private # ====================================================================================================
  
  def concert_params
    params.require(:concert).permit(:name, :street_address, :zip)
  end
  
  # Used in `index` and `destroy`.
  
  def find_concerts
    @sort = params[:sort] || 'Rank'
    @order = ( params[:sort] == 'Votes' ? 'desc' : 'asc' )
    if @genre == 'All'
      Concert.includes(:genre, :venue, :city, :state, :country).order("#{@sort}, Name #{@order}").
        page(params[:concerts_page]).per_page(params[:size].present? ? params[:size].to_i : 10)
    else
      Concert.joins(:genre).where(genres: { name: params[:genre] } ).
        preload(:genre, :venue, :city, :state, :country).order("#{@sort}, Name #{@order}").
        page(params[:concerts_page]).per_page(params[:size].present? ? params[:size].to_i : 10)
    end
  end
end
