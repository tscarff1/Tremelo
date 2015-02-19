class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :upload_pic, :update_pic, 
    :edit_tags,
    :update, :destroy]

  # GET /users/new
  def new
    @user = User.new
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        format.html { redirect_to @user, notice: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # GET /users/1/edit
  def edit
  end

  def edit_tags
  end


  def change_password
  end

  def upload_pic
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
      @user.address = @user.get_address
      @user.save
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

  def update_tags
    #for some reason it doesn't work if the following line is included in the set_user stuff
    @user = User.find(session[:user_id])

    #First let's clear out all existing UserTags
    for user_tag_old in UserTags.where(user_id: @user.id)
      user_tag_old.destroy
    end

    for i in params[:tag_ids]
      user_tag = UserTags.new(user_id: @user.id, tag_id: i)
      user_tag.save
    end
    redirect_to @user
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

  def search
  end

  def search_results
    @searching_by = []
    #Display name results
    name_results = []
    if !params[:display_name].empty?
      @searching_by.push("display name")
      name_results = User.where(display_name: params[:display_name])
    end

    location_results = []

      if (!params[:location].nil? && 
        !params[:location].empty? && !params[:distance].empty?)
      @searching_by.push("location")
      temp_user = User.new(address: params[:location])
      temp_user.save
      if(!temp_user.nearbys(params[:distance].to_i).nil?)
        for user in temp_user.nearbys(params[:distance].to_i)
          location_results.push(user)
        end
      end
      temp_user.destroy
    end

    #@results is the interection of arrays produced by previous searches, ignoring empty results    
    all_results = [name_results, location_results]
    @results = all_results.tap{ |a| a.delete( [] ) }.reduce( :& ) || []


    #Instrument tag results
    # Due to the fact that the array will remain empty if no tags are found, this needs to come last
    tag_results = []
    if(!params[:tag_ids].nil?)
      @searching_by.push("instrument tags")
      for user in User.all
        if (params[:exact_tags].nil?)
          if user.has_at_least_one_tag_from?(params[:tag_ids])
            tag_results.push(user)
          end
        else
          if user.has_tags?(params[:tag_ids])
            tag_results.push(user)
          end
        end
      end

      #This next line is why this has to be last
      if (@results.empty?)
        @results = tag_results
      else
        @results = @results & tag_results
      end
    end

    #End of the eternal search method
    #Now it's really the end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:display_name, :first_name, :last_name, :email, :about_me, 
                            :email_confirmation, 
                            :password, :password_confirmation, 
                            :profile_picture, 
                            :address, :city, :state)
    end

    def picture_params
      params.require(:user).permit(:profile_picture)
    end
end
