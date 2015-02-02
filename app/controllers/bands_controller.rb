class BandsController < ApplicationController
  def new
  	@band = Band.new
    @userband = UserBand.new(user_id: params[:user_id], 
                            band_id: @band.id, 
                            admin_priveleges: 1)
  end

  def create
  	@band = Band.new(band_params)
    
  	if @band.save
  	  	flash[:success] = "Welcome to Tremelo"
        @user = User.find(session[:user_id])
        session.delete(:user_id)
        @userband = UserBand.new(user_id: @user.id, band_id: @band.id, admin_priveleges: 1)
        @userband.save
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
