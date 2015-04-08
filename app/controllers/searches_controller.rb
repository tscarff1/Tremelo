class SearchesController < ApplicationController

	def new
		session[:search_params] ||= {}
		@search = Search.new
	end

	def create
		current_step = session[:current_step]
		@search = Search.new(current_step: session[:search_step])
		@search.current_step = session[:search_step]
		

		# Set only vars in the session that are changed
		if(@search.current_step == "band_or_user")
			#Delete the tag ids if we switch between user and band search
			if session[:band_or_user] != params[:band_or_user]
				session.delete(:tag_ids)
			end

			session[:band_or_user] = params[:band_or_user] #works

		elsif @search.current_step == "location"
			session[:center_city] = params[:center_city]
			session[:center_state] = params[:center_state]
			session[:radius] = params[:radius]
		elsif @search.current_step == "tags"
			session[:tag_ids] = params[:tag_ids] 
		else
			
		end


		if params[:back]
			@search.prev_step
		else
			@search.next_step
		end
		session[:search_step] = @search.current_step
		render "new"
	end

	def delete
		session.delete(:search_step)
		session.delete(:band_or_user)
		session.delete(:center_city)
		session.delete(:radius)
		session.delete(:center_state)
		redirect_to new_search_path
	end
end
