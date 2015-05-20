class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :upload_pic, :update_pic,
    :edit_tags, :access_error,
    :update, :destroy]
  before_action :set_user_by_session, only: [:notifications]

  before_action :verify_correct_user, only: [:edit, :edit_tags, :upload_pic, :notifications]

  # URLs now dsplay with form users/:display_name, so paths need to be pass as name_of_path(user.display_name)
  # or in some cases, just user.display_name

  # GET /users/new
  def new
    @user = User.new
    @bands = Band.all
    @tags = Tag.all
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)
    @tags = Tag.all
    respond_to do |format|
      if @user.save
        session[:user_id] = @user.id
        flash[:notice] = "Thanks for signing up!"
        format.html { redirect_to @user, success: 'User was successfully created.' }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def index
    @user = User.find(session[:user_id])
    @users = @user.nearbys(5_100)
    if !@users.nil?
      @users.push(@user)
    end
    #This hash will be passed to the map and accessed to add users to it
    @hash = Gmaps4rails.build_markers(@users) do |user, marker|
      marker.lat user.latitude
      marker.lng user.longitude
      #Locals are the local variables passed (Pretty sure just the user is needed)
      marker.infowindow render_to_string(:partial => "/users/infowindow", :locals => {:user => user})
      if(user == @user)
      marker.picture({
                  :url => "#{view_context.image_path('marker.png')}",
                  :width   => 32,
                  :height  => 32
                 })
      end
    end
  end

  def show
   
  end

  def edit
    @bands = Band.all
    @tags = Tag.all
  end

  def notifications
    @notifications = Notification.where(user_id: @user.id)
  end

  def accept_band
    band_id = params[:band_id]
    user_id = params[:user_id]
    accepting = params[:accepting]
    user = User.find(user_id)
    band = Band.find(band_id)
    if accepting == 'true'
      userband = UserBand.new(band_id: band_id, user_id: user_id, admin_priveleges: 0)
      
      respond_to do |format|
        if userband.save
          
          format.html { redirect_to band, success: "You have joined #{band.name}" }
          format.json { render :show, status: :created, location: band }
        else
          format.html { redirect_to notifications_users_path, error: "Unable to join #{band.name}" }

        end # end save check
        #Now that we have accepted the invite, destroy it and any duplicates
           for n in Notification.where(band_id: band_id, user_id: user_id)
            n.destroy
           end
      end
    else
      for n in Notification.where(band_id: band_id, user_id: user_id)
        n.destroy
      end
      respond_to do |format|
        format.html { redirect_to notifications_path(user), 
        notice: "You have rejected #{band.name}" }
      end
    end #End accepting if
    
    
  end

  def access_error
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

    if !session[:user_id].nil?
      user_params[:email_confirmation] = user_params[:email]
    end

    @tags = Tag.all
    @user.updating = true
    #Now update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, success: 'User was successfully updated.' }
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

    #First let's clear out all existing UserTag
    for user_tag_old in UserTag.where(user_id: @user.id)
      user_tag_old.destroy
    end
    if(!params[:tag_ids].nil?)
      for i in params[:tag_ids]
        user_tag = UserTag.new(user_id: @user.id, tag_id: i)
        user_tag.save
      end
    end
    redirect_to @user
  end

  def update_pic

    temp = @user.profile_picture
    @user.profile_picture.destroy
    new_pic = params[:profile_picture]
    @user.profile_picture = new_pic
    respond_to do |format|
      if @user.save
        format.html {redirect_to @user, success: 'Profile picture has been successfully changed.'}
        format.json {render :show, status: :ok, location: @user}
      else
        @user.profile_picture = temp
        @user.save
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
      format.html { redirect_to users_url, success: 'User was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def leave_band
      @userband = UserBand.find(params[:userband_id])
      @band = Band.find(@userband.band_id)
      @user = User.find(@userband.user_id)
      if @userband.destroy
       redirect_to @user, success: "Successfully left #{@band.name}"
       if @band.num_members == 0
        @band.destroy
      end
      else
        redirect_to @user, error: "Unable to leave band"
      end
  end

  def search
  end

  def search_results
    @searching_by = []
    #Display name results
    name_results = []
    if params.has_key?(:display_name)
      @searching_by.push("display name")
      name_results = User.where(display_name: params[:display_name])
    end

    location_results = []

      if (params.has_key?(:location) && params.has_key?(:distance))
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

    @hash = Gmaps4rails.build_markers(@results) do |user, marker|
      marker.lat user.latitude
      marker.lng user.longitude
      #Locals are the local variables passed (Pretty sure just the user is needed)
      marker.infowindow render_to_string(:partial => "/users/infowindow", :locals => {:user => user})
      if(user.id == session[:user_id])
        marker.picture({
                  :url => "#{view_context.image_path('marker.png')}",
                  :width   => 32,
                  :height  => 32
                 })
      end
    end
    #End of the eternal search method
    #Now it's really the end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find_by(display_name: params[:display_name])
    end

    def set_user_by_session
      @user = User.find(session[:user_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:display_name, :first_name, :last_name, :about_me,
                            :email, :email_confirmation, 
                            :password, :password_confirmation, :service,
                            :profile_picture, 
                            :address, :city, :state, :dob, band_ids: [], tag_ids: [])
    end

    def picture_params
      params.require(:user).permit(:profile_picture)
    end

    def verify_correct_user
      if(!logged_in?)
        redirect_to new_user_session_path, notice: "You must be logged in to access that page."
      elsif(@user.id != session[:user_id])
        flash[:error] = "You cannot access that page."
        redirect_to current_user
      end
    end
end
