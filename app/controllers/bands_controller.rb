class BandsController < ApplicationController

  before_action :set_band, only: [:show, :edit, :upload_pic, :update_pic, :update, 
    :destroy, :access_error]
  before_action :verify_admin, only: [:edit, :upload_pic]

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
  
  # PATCH/PUT /bands/1
  # PATCH/PUT /bands/1.json
  def update
    #First destroy the current profile picture if we are updating it
    if !band_params[:profile_picture].nil?
      @band.profile_picture.destroy
    end

    #Now update
    respond_to do |format|
      if @band.update(band_params)
        format.html { redirect_to @band, notice: 'Band was successfully updated.' }
        format.json { render :show, status: :ok, location: @band }
      else
       
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
  end

  def upload_pic
  end

  def show
  end

  def access_error

  end

  private
    def set_band
      @band = Band.find(params[:id])
    end

  	def band_params
  		params.require(:band).permit(:name, :location, :about_me, :profile_picture,
       :full_address, :video_link)
  	end

    #Method to make sure the logged in user has access to the page
    def verify_admin
      #First make sure we are even logged in
      if session[:user_id].nil?
        redirect_to action: "access_error", id:@band.id
      else
        @userband = UserBand.find_by(user_id: session[:user_id], band_id: @band.id)

        #first verify that the user is a member of the band
        if @userband.nil?
          redirect_to action: "access_error", id:@band.id
        else
          if @userband.admin_priveleges == 0
            redirect_to action: "access_error", id: @band.id
          end
        end
      end
      @user = User.find(session[:user_id])
    end
end
