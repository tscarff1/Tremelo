class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :upload_pic, :update_pic, :update, :destroy]

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  def change_password
  end

  def upload_pic
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        flash[:success] = "Thanks for signing up!"
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    #First destroy the current profile picture if we are updating it
    if !user_params[:profile_picture].nil?
      @user.profile_picture.destroy
    end

    #Now update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { render :show, status: :ok, location: @user }
      else
       if params[:profile_picture].nil?
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        else
          format.html { render :upload_pic }
          format.json { render json: @user.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  def update_pic
    respond_to do |format|
      if @user.update(picture_params)
        format.html {redirect_to @user, notice: 'Profile picture has been successfully changed.'}
        format.json {render :show, status: :ok, location: @user}
      else
        format.html {render :upload_pic}
        format.json {render json: @user.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url, notice: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def leave_band
      @userband = UserBand.find(params[:userband_id])
      @band = Band.find(@userband.band_id)
      @user = User.find(@userband.user_id)
      if @userband.destroy
       redirect_to @user, notice: "Successfully left band #{@band.name}"
       if @band.num_members == 0
        @band.destroy
      end
      else
        redirect_to @user, notice: "Unable to leave band"
      end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:display_name, :first_name, :last_name, :email, :about_me 
                            :email_confirmation, 
                            :password, :password_confirmation, 
                            :profile_picture, :address)
    end

    def picture_params
      params.require(:user).permit(:profile_picture)
    end
end
