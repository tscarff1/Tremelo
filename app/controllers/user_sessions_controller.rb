class UserSessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])
    if user && user.authenticate(params[:password])
      if params[:remember_me]
        signed_token = Rails.application.message_verifier(:remember_me).generate(user.id)
        cookies.permanent.signed[:remember_me_token] = signed_token
      end
      session[:user_id] = user.id
      flash[:success] = "Successfully logged in"
      redirect_to user
    else
      flash[:error] = "There was a problem logging in. Please check your email and password."
      render action: 'new'
    end
  end

  def destroy
    session[:user_id] = nil
    cookies.delete(:remember_me_token)
    reset_session
    redirect_to root_path, success: "You've logged out"
  end
end
