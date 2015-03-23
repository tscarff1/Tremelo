class MessagesController < ApplicationController
	before_action :set_user, only: [:new]
	before_action :set_user, only: [:new]

	def new

	end

	private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(session[:user_id])
    end

    def verify_correct_user
      if(session[:user_id].nil?)
        redirect_to action: "access_error", id:@user.id
      
      elsif(@user.id != session[:user_id])
        redirect_to action: "access_error", id:@user.id
      end
    end
end
