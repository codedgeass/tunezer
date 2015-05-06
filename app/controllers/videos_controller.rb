class VideosController < ApplicationController
  before_action :authenticate_user!, only: [:new, :create, :destroy]
  
  def new
    @concert = Concert.find(params[:concert_id])
    @video = Video.new
    respond_to do |format|
      format.html { redirect_to concert_path(@concert, new_video?: true) }
      format.js
    end
  end
  
  def create
    @concert = Concert.find(params[:concert_id])
    @video = @concert.videos.build
    if @video.update video_params
      @videos = @concert.videos.page(1)
      @videos = @videos.page(@videos.total_pages)
      respond_to do |format|  
        format.html { redirect_to @concert, 
          notice: "Congratulations! The video at #{@video.url} was successfully added!" }
        format.js
      end
    else
      respond_to do |format|
        format.html { redirect_to @concert, notice: 'Your video could not be added because it was
          either not a valid youtube URL, or it already exists on our website.' }
        format.js { render 'new' }
      end
    end
  end
  
  def index
    @concert = Concert.find(params[:concert_id])
    @videos = @concert.videos.page(params[:videos_page])
    respond_to do |format|
      format.html { redirect_to @concert, notice: 'Enable Javascript to view videos.' }
      format.js
    end
  end
  
  def show
    @video = Video.find(params[:id])
    respond_to do |format|
      format.html { redirect_to concert_path(@video.concert_id), notice: 'Enable Javascript to view videos.' }
      if params[:reference_video]
        format.js { render 'create_video_reference' }
      else
        format.js
      end
    end
  rescue ActiveRecord::RecordNotFound
    respond_to do |format|
      format.html { redirect_to concert_path(params[:concert_id]), 
        alert: 'That video has been deleted. Sorry!' }
      format.js { render 'alert_video_not_found' }
    end
  end
  
  def destroy
    @video = Video.find(params[:id])
    @video.destroy
    @concert = Concert.find(params[:concert_id])
    calculate_video_page unless @concert.videos.size == 0
  end
  
  private # ====================================================================================================
  
  def calculate_video_page
    video_number = params[:video_number].to_i
    videos_page = (video_number / -2) * -1        # Divide by negative to round the quotient up.
    if video_number != 1 && video_number % 2 == 1
      @videos = @concert.videos.page(videos_page - 1)
    else
      @videos = @concert.videos.page(videos_page)
    end
  end
  
  def video_params
    params.require(:video).permit(:url)
  end
end