class PlacesController < ApplicationController
  def index
  end

  def show
    if session[:last_city_searched]
      @place = BeermappingApi.find_place(params[:id], session[:last_city_searched])
    else
      render :index
    end
  end

  def search
    @places = BeermappingApi.places_in(params[:city])

    session[:last_city_searched] = params[:city]

    if @places.empty?
      redirect_to places_path, notice: "No locations in #{params[:city]}"
    else
      render :index
    end
  end
end
