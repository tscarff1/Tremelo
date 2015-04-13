class SearchesController < ApplicationController

	def new
		session[:search_params] ||= {}
		@search = Search.new
		
	end

	def create
		session[:search_params] ||= {}
		current_step = session[:search_params][:current_step]
		@search = Search.new(current_step: session[:search_params][:search_step])
		@search.current_step = session[:search_params][:search_step]
		

		# Set only vars in the session that are changed
		if(@search.current_step == "band_or_user")
			#Delete the tag ids if we switch between user and band search
			if session[:search_params][:band_or_user] != params[:band_or_user]
				session.delete(:tag_ids)
			end

			session[:search_params][:band_or_user] = params[:band_or_user] #works

		elsif @search.current_step == "location"
			session[:search_params][:center_city] = params[:center_city]
			session[:search_params][:center_state] = params[:center_state]
			session[:search_params][:radius] = params[:radius]
		elsif @search.current_step == "tags"
			session[:search_params][:tag_ids] = params[:tag_ids] 
		else
			
		end


		if params[:back]
			@search.prev_step
			to_render = "new"
		elsif params[:search]
			to_render = "results"
		else
			@search.next_step
			to_render = "results"
		end
		session[:search_params][:search_step] = @search.current_step
		render to_render
	end
end
