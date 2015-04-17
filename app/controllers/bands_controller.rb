require "net/http"

class BandsController < ApplicationController
  
  after_action :set_band_admin, only: [:create]
  before_action :set_band, only: [:show, :edit, 
    :edit_genres, :upload_pic, :edit_videos, :edit_musics, 
    :update, :update_genres, :update_pic, :update_videos, :delete_videos, :destroy_videos,
    :update_musics, :destroy_musics, :delete_musics,
    :destroy, :access_error,  :add_member, :destroy_videos]
  before_action :verify_admin, only: [:edit, :upload_pic, :edit_videos, :delete_videos, :edit_genres]

  def new
    if !session[:user_id].nil?
  	  @band = Band.new
      @users = User.all
      @genres = Genre.all
    else

    end
  end

  def create
  	@band = current_user.bands.new(band_params)
    @genres= Genre.all
    # @userband = UserBand.new(user_id: @user.id, band_id: @band.id, admin_priveleges: 1)
    respond_to do |format|
      if @band.save
        format.html { redirect_to new_band_band_music_path(@band), notice: 'Welcome to Tremelo!' }
        format.json { render :show, status: :created, location: @band }
      else
        format.html { render :new}
        format.json { render json: @user.errors, status: :unprocessable_entity }
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

    if !params[:user_id].nil?
    end
    
    @genres= Genre.all
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

  def add_member
    notification = BandInvite.new(band_id: @band.id, 
      content: "#{@band.name} has invited you to be a member", 
      special_chars: "%B",
      user_id: params[:user_id])
    respond_to do |format|
      if notification.save
          format.html { redirect_to @band, notice: 'User has been sent an invitation.' }
          format.json { render :show, status: :ok, location: @band }
      else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @users = User.all
    @genres = Genre.all
  end

  def edit_genres
  end

  def update_genres
    #First let's clear out all existing UserTags
    for band_genre_old in BandGenre.where(band_id: @band.id)
      band_genre_old.destroy
    end
    if(!params[:genre_ids].nil?)
      for i in params[:genre_ids]
        band_genre = BandGenre.new(band_id: @band.id, genre_id: i)
        band_genre.save
      end
    end
    redirect_to @band
  end

  def upload_pic
  end

  def fetch_videos
    @band_video = BandVideo.find(params[:id])
    respond_to do |format|
      format.js
    end
  end

  def add_video
    redirect_to new_band_band_video_path(@band)
  end

  def edit_musics
    redirect_to edit_band_band_musics_path(@band.name)
  end
  # def update_videos
  #   @bandvideo = BandVideo.new(band_id: @band.id, video_link: params[:video_link], 
  #     video_name: params[:video_name])
  #   respond_to do |format|
  #     if @bandvideo.save && url_exist?(params[:video_link])
  #       content = "#{@band.name} has added a new video: #{params[:video_name]}"
  #       @band.send_notification_to_members_except(content, session[:user_id])
  #       format.html { redirect_to @band, success: 'Video successfully added' }
  #       format.json { render :show, status: :created, location: @band }
  #     else
  #       format.html { render :edit_videos }
  #       format.json { render json: @bandvideo.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  # def destroy_videos
  #   if(!params[:video_ids].nil?)
  #     for video_id in params[:video_ids]
  #       video = BandVideo.find(video_id)
  #       content = "#{@band.name} has deleted a video: #{video.video_name}"
  #       @band.send_notification_to_members_except(content, session[:user_id])
  #       video.destroy
  #     end
  #   end

  #   redirect_to @band
  # end

  def from_musics
    @selected = BandMusic.find(params[:music_id])
    respond_to do |format|
      format.js
    end
  end

  def update_musics


    if url_exist?(params[:video_link])
      bandmusic = BandMusic.new(band_id: @band.id, embed_html: params[:embed_html].html_safe, 
        name: params[:music_name])
      bandmusic.save
      content = "#{@band.name} has added new music: #{params[:music_name]}"
      @band.send_notification_to_members_except(content, session[:user_id])
    end

    redirect_to @band
  end

  def destroy_musics
    if(!params[:music_ids].nil?)
      for music_id in params[:music_ids]
        music = BandMusic.find(music_id)
        content = "#{@band.name} has deleted music: #{music.name}"
        @band.send_notification_to_members_except(content, session[:user_id])
        music.destroy
      end
    end

    redirect_to @band
  end

  def show
    @musics = BandMusic.where(band_id: @band.id)
    loggedin_userband = UserBand.find_by(user_id: session[:user_id], band_id: @band.id)
    @user_verified = false
    if !loggedin_userband.nil?
      if loggedin_userband.admin_priveleges == 1
        @user_verified = true
      end
    end
  end

  def access_error

  end

  def new_user_search
    case params[:form]
    when "stage 1"
      render partial: 'search_stage_1'
    else
      render partial: 'search_stage_1'
    end
  end

  def user_search_results
    @searching_by = []
    #Display name results
    name_results = []
    if !params[:display_name].empty?
      @searching_by.push("name")
      name_results = User.where(display_name: params[:display_name])
    end

    location_results = []
    if (!params[:location].empty? && !params[:distance].empty?)
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


    #Genre tag results
    # Due to the fact that the array will remain empty if no tags are found, this needs to come last
    tag_results = []
    if(!params[:tag_ids].nil?)
      @searching_by.push("instrument tags")
      for user in User.all
        if (params[:exact_tags].nil?)
          if user.has_at_least_one_genre_from?(params[:tag_ids])
            tag_results.push(user)
          end
        else
          if user.has_genres?(params[:tag_ids])
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

  def search_results
    @searching_by = []
    #Display name results
    name_results = []
    if params.has_key?(:name)
      @searching_by.push("display name")
      name_results = Band.where(name: params[:name])
    end


     location_results = []
    if (!params[:location].empty? && !params[:distance].empty?)
      @searching_by.push("location")
      temp_band = Band.new(full_address: params[:location])
      temp_band.save
      if(!temp_band.nearbys(params[:distance].to_i).nil?)
        for band in temp_band.nearbys(params[:distance].to_i)
          location_results.push(band)
        end
      end
      temp_band.destroy
    end

    #@results is the interection of arrays produced by previous searches, ignoring empty results    
    all_results = [name_results, location_results]
    @results = all_results.tap{ |a| a.delete( [] ) }.reduce( :& ) || []

    #Genre tag results
    # Due to the fact that the array will remain empty if no tags are found, this needs to come last
    tag_results = []
    if(!params[:tag_ids].nil?)
      @searching_by.push("genre tags")
      for band in Band.all
        if (params[:exact_tags].nil?)
          if band.has_at_least_one_genre_from?(params[:tag_ids])
            tag_results.push(band)
          end
        else
          if band.has_genres?(params[:tag_ids])
            tag_results.push(band)
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


    @results
  end

  private
    def set_band
      @band = Band.find_by(name: params[:name])
    end

  	def band_params
  		params.require(:band).permit(:name, :location, :about_me, :profile_picture,
       :full_address, :video_link, user_ids: [], genre_ids: [],band_video_attributes: [:video_link, :video_name], band_music_attributes: [:name, :embed_html])
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
    def set_band_admin

      UserBand.create(user_id: current_user.id, band_id: @band.id, admin_priveleges: 1)
    end
end
