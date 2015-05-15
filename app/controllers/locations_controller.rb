class LocationsController < ApplicationController
  def index
    cities = City.where('name ILIKE ?', "%#{params[:term]}%").limit(4)
    states = State.where('name ILIKE ?', "%#{params[:term]}%").limit(3)
    countries = Country.where('name ILIKE ?', "%#{params[:term]}%").limit(3)
    locations = cities + states + countries
    render json: locations.map { |location| { label: location.name, 
      value: "locations/#{location.id}?klass=#{location.class}" } }
  end
  
  def show
    @location = params[:klass].constantize.find(params[:id])
    @comment = Comment.new
    @comments = @location.comments.page(1)
    @concerts = @location.concerts.best_rank.page(1)
  end
end