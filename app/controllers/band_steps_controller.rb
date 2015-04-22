class BandStepsController < ApplicationController
	include Wicked::Wizard
	steps :basic, :genres, :members, :videos, :music

	def show
		@band = Band.find(session[:band_id])
		render_wizard
	end

	def update
		@band = Band.find(session[:band_id])
		@band.attributes = band_params
		render_wizard @band
	end

	private
	  	def band_params
	  		params.require(:band).permit(:name, :location, :about_me, :profile_picture,
	       :full_address, :video_link, user_ids: [], genre_ids: [],band_video_attributes: [:video_link, :video_name], band_music_attributes: [:name, :embed_html])
	  	end

	  	def redirect_to_finish_wizard
	  		band = Band.find(session[:band_id])
	  		session.destroy(:band_id)
	  		redirect_to band
	  	end
end
