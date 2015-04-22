class NotificationsController < ApplicationController
  include ActionController::Live

  def index
    response.headers['Content-Type'] = 'text/event-stream'
    sse = SSE.new(response.stream)

    begin
      Notification.after_create do |data|
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
    redirect_to notifications_users_path
  end

  def test
    redirect_to params[:current_page]
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
