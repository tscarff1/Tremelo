class BandsController < ApplicationController
  def new
  	@band = Band.new
  end

  def create
  	@band = Band.new(band_params)
  	if @band.save
  	  	flash[:success] = "Welcome to Tremelo"
  		redirect_to @band
  	else
  		render 'new'
  	end
  end

  def edit
  	@band = Band.find(params[:id])
  end

  def show
  	@band = Band.find(params[:id])
  end

  private
  	def band_params
  		params.require(:band).permit(:name, :location, :about_me)
  	end
end
