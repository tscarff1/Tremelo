class GenresController < ApplicationController
  before_action :require_user
  before_action :set_genre
  def new
    @genre = Genre.new
    @bands = Band.all
  end

  def edit
    @bands = Band.all
  end

  private
  def set_band
    @band = Band.find(params[:id])
  end


  def genre_params
    params.require(:genre).permit(:content, band_ids: [])
  end

end
