class Search < ActiveRecord::Base
	attr_writer :current_step
	attr_writer :search_params

	def current_step
		@current_step || self.steps.first
	end

	def steps
		%w[band_or_user location tags]
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
end
