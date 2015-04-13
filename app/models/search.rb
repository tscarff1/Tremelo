class Search < ActiveRecord::Base
	attr_writer :current_step
	attr_writer :search_params

	def current_step
		@current_step || self.steps.first
	end

	def search_params
		@search_params || nil
	end

	def steps
		%w[band_or_user location tags results]
	end

	def next_step
		self.current_step = steps[steps.index(current_step)+1]
	end

	def prev_step
		self.current_step = steps[steps.index(current_step)-1]
	end

	def first_step?
		current_step == steps.first
	end

	def last_step?
		current_step == steps.last
	end

	def get_results
		if search_params["band_or_user"] == "user"
			@searching_by = []
		    #Display name results
		    name_results = []
		    if search_params.has_key?("display_name")
		    	@searching_by.push("display name")
		    	name_results = User.where(display_name: search_params["display_name"])
		    end

		    location_results = []

		    if (search_params.has_key?("center_city") && search_params.has_key?("radius") && search_params.has_key?("center_state"))
		    	@searching_by.push("location")
		    	temp_user = User.new(address: "#{search_params['center_city']}, #{search_params['center_state']}")
		    	temp_user.save
		      	if(!temp_user.nearbys(search_params["radius"].to_i).nil?)
		        	for user in temp_user.nearbys(search_params["radius"].to_i)
		          		location_results.push(user)
		        	end
		      	end
		      temp_user.destroy
		    end

		    #results is the interection of arrays produced by previous searches, ignoring empty results    
		    all_results = [name_results, location_results]
		    results = all_results.tap{ |a| a.delete( [] ) }.reduce( :& ) || []


		    #Instrument tag results
		    # Due to the fact that the array will remain empty if no tags are found, this needs to come last
		    tag_results = []
		    if(!search_params["tag_ids"].nil?)
		      @searching_by.push("instrument tags")
		      for user in User.all
		        	if user.has_at_least_one_tag_from?(search_params["tag_ids"])
		          		tag_results.push(user)
		        	end
		        end
		    end

		    #This next line is why this has to be last
		    if (results.empty?)
		        results = tag_results
		    else
		        results = results & tag_results
		    end
		# END USER SEARCH
		elsif search_params["band_or_user"] == "band"
		# ----------------------- Band Search ----------------------
			@searching_by = []
		    #Display name results
		    name_results = []
		    if search_params.has_key?("name")
		      @searching_by.push("display name")
		      name_results = Band.where(name: params[:name])
		    end


		     location_results = []
		    if (!search_params["center_city"].empty? && !search_params["center_state"]&&!search_params["radius"].empty?)
		      @searching_by.push("location")
		      temp_band = Band.new(full_address: "#{search_params['center_city']}, #{search_params['center_state']}")
		      temp_band.save
		      if(!temp_band.nearbys(search_params["radius"].to_i).nil?)
		        for band in temp_band.nearbys(search_params["radius"].to_i)
		          location_results.push(band)
		        end
		      end
		      temp_band.destroy
		    end

		    #results is the interection of arrays produced by previous searches, ignoring empty results    
		    all_results = [name_results, location_results]
		    results = all_results.tap{ |a| a.delete( [] ) }.reduce( :& ) || []

		    #Genre tag results
		    # Due to the fact that the array will remain empty if no tags are found, this needs to come last
		    tag_results = []
		    if(!search_params["tag_ids"].nil?)
		      @searching_by.push("genre tags")
		      for band in Band.all
		          if band.has_at_least_one_genre_from?(search_params["tag_ids"])
		            tag_results.push(band)
		          end
		      end
		      #This next line is why this has to be last
		      if (results.empty?)
		        results = tag_results
		      else
		        results = results & tag_results
		      end
		    end
		end
		return results
	end
end
