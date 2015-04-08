class BandMusicsController < ApplicationController
  before_action :require_user
  before_action :find_band

  def new
    @band_music = BandMusic.new
  end

  def create
    @band_music = @band.band_musics.new(band_music_params)
    if @band_music.save
      content = "#{@band.name} has added new music: #{params[:name]}"
      @band.send_notification_to_members_except(content, session[:user_id])
      flash[:success] = "Music successfully added"
      redirect_to new_band_band_video_path(@band)
    else
      flash[:error] = "There was a problem adding the music."
      render action: :new
    end
  end

  def edit
    @band_music = @band.band_musics.find(params[:id])
  end
  
  def update
    @band_music = @band.band_musics.find(params[:id])
    if @band_music.update_attributes(band_music_params)
      flash[:success] = "Saved music."
      redirect_to @band
    else
      flash[:error] = "That music could not be saved."
      render action: :edit
    end
  end

  def destroy
    @band_music = @band.band_musics.find(params[:id])
    if @band_music.destroy
      flash[:success] = "Music was deleted."
    else
      flash[:error] = "Music could not be deleted."
    end
    redirect_to @band

  end
  def new_band_setup
    @band_music = @band.band_musics.new(band_music_params)
    @band_music.save
    redirect_to new_band_setup_path(@band)
  end
  private
  def find_band
    @band = current_user.bands.find(params[:band_id])
  end

  def band_music_params
    params.require(:band_music).permit(:embed_html, :name, band_attributes: [:id])
  end

end
