class BandVideosController < ApplicationController
  before_action :require_user
  before_action :find_band

	def new
    @band_video = BandVideo.new
	end

	def create
    @band_video = @band.band_videos.new(band_video_params)
    if @band_video.save
      content = "#{@band.name} has added a new video: #{params[:video_name]}"
      @band.send_notification_to_members_except(content, session[:user_id])
      flash[:success] = "Video successfully added"
      redirect_to @band
    else
      flash[:error] = "There was a problem adding video."
      render action: :new
    end
	end

  def edit
    @band_video = @band.band_videos.find(params[:id])
  end
  
  def update
    @band_video = @band.band_videos.find(params[:id])
    if @band_video.update_attributes(todo_item_params)
      flash[:success] = "Saved video."
      redirect_to @band
    else
      flash[:error] = "That video could not be saved."
      render action: :edit
    end
  end

	def destroy
    @band_video = @band.band_videos.find(params[:id])
    if @band_video.destroy
      flash[:success] = "Video was deleted."
    else
      flash[:error] = "Video could not be deleted."
    end
    redirect_to @band

	end
  def from_videos
    @selected = BandVideo.find(params[:video_id])
    respond_to do |format|
      format.js
    end
  end

  private
  def find_band
    @band = current_user.bands.find(params[:band_id])
  end

  def band_video_params
    params.require(:band_video).permit(:video_name, :video_link, band_attributes: [:id])
  end

end
