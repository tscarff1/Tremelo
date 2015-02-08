class BandsController < ApplicationController
  def new
    if !session[:user_id].nil?
  	  @band = Band.new
      @userband = UserBand.new(user_id: session[:user_id], 
                            band_id: @band.id, 
                            admin_priveleges: 1)
    else

    end
  end

  def create
  	@band = Band.new(band_params)
    
    respond_to do |format|
      if @band.save
        @user = User.find(session[:user_id])
        @userband = UserBand.new(user_id: @user.id, band_id: @band.id, admin_priveleges: 1)
          if @userband.save
            format.html { redirect_to @band, notice: 'Welcome to Tremelo!' }
            format.json { render :show, status: :created, location: @band }
          end
      else
        format.html { render :new}
        format.json { render json: @band.errors, status: :unprocessable_entity }
      end
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
