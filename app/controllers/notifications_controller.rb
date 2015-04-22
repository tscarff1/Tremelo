class NotificationsController < ApplicationController

  def new
    notification = Notification.create(user_id: session[:user_id],
                                        content: SecureRandom.hex(5))
    redirect_to notifications_users_path
  end

  def test
    redirect_to params[:current_page]
  end

  def index
    @user = User.find(session[:user_id])
    @notifications = Notification.where(user_id: @user.id)
  end

  def destroy
  	if (!params[:id].nil?) 
  		note = Notification.find(params[:id])
  		note.destroy
  		respond_to do |format|
        format.html { redirect_to notifications_users_path, error: "Notification deleted" }
     end
   end
 end

end
