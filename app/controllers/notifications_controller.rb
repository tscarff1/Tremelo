class NotificationsController < ApplicationController
  include ActionController::Live

  def index
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream)

    begin
      Notification.on_change do |data|
        sse.write(data)
      end
    rescue IOError
      # Client Disconnected
    ensure
      sse.close
    end
    render nothing: true
  end

  def new
    notification = Notification.create(user_id: session[:user_id],
                                        content: SecureRandom.hex(5))
    redirect_to index_notifications_path
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
        format.html { redirect_to index_notifications_path, error: "Notification deleted" }
     end
   end
 end

end
