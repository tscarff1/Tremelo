require "net/http"

class BandsController < ApplicationController

  before_action :set_band, only: [:show, :edit, 
    :edit_genres, :upload_pic, :edit_videos, :edit_musics, 
    :update, :update_genres, :update_pic, :update_videos, :delete_videos, :destroy_videos,
    :update_musics, :destroy_musics, :delete_musics,
    :destroy, :access_error,  :add_member, :destroy_videos]
  before_action :verify_admin, only: [:edit, :upload_pic, :edit_videos, :delete_videos, :edit_genres]

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

    if !params[:user_id].nil?
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

  def add_member
    notification = BandInvite.new(band_id: @band.id, content: "#{@band.name} has invited you to be a member", user_id: params[:user_id])
    respond_to do |format|
      if notification.save
          format.html { redirect_to @band, notice: 'User has been sent an invitation.' }
          format.json { render :show, status: :ok, location: @band }
      else
          format.html { render :edit }
          format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end


    #user_band = UserBand.new(user_id: params[:user_id], band_id: @band.id, admin_priveleges: 0)
    #if user_band.save
    #  redirect_to @band
    #end
  end

  def edit
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

  def edit_videos
  end

  def delete_videos
  end

  def from_videos
    @selected = BandVideo.find(params[:video_id])
    respond_to do |format|
      format.js
    end
  end

  def update_videos

    if url_exist?(params[:video_link])
      bandvideo = BandVideo.new(band_id: @band.id, video_link: params[:video_link], 
        video_name: params[:video_name])
      if bandvideo.save
        flash[:success]="Video successfully added"
      end
    else
      flash[:error] = "Video not added"
    end
    redirect_to @band

  end

  def destroy_videos
    if(!params[:video_ids].nil?)
      for video_id in params[:video_ids]
        video = BandVideo.find(video_id)
        video.destroy
      end
    end

    redirect_to @band
  end

  def from_musics
    @selected = BandMusic.find(params[:music_id])
    respond_to do |format|
      format.js
    end
  end

  def update_musics

    if (!params[:embed_html].empty? && !params[:music_name].empty?)
      bandmusic = BandMusic.new(band_id: @band.id, embed_html: params[:embed_html].html_safe, 
        name: params[:music_name])
      bandmusic.save
    end

    redirect_to @band
  end

  def destroy_musics
    if(!params[:music_ids].nil?)
      for music_id in params[:music_ids]
        music = BandMusic.find(music_id)
        music.destroy
      end
    end

    redirect_to @band
  end

  def show
    @videos = BandVideo.where(band_id: @band.id)
    @musics = BandMusic.where(band_id: @band.id)
  end

  def access_error

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
