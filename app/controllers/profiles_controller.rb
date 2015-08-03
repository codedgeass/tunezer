class ProfilesController < ApplicationController
  before_action :authenticate_user!
  
  def show
    @profile = Profile.find(params[:id])
    @notifications = @profile.notifications
  end

  def edit
    @profile = Profile.find(params[:id])
  end

  def update
    @profile = Profile.find(params[:id])
    if @profile.update profile_params
      redirect_to @profile
    else
      render :edit
    end
  end
  
  private # ====================================================================================================
  
  def profile_params
    params.require(:profile).permit(:real_name, :age, :hometown, :favorite_artists, :favorite_songs)
  end
end
