class BandVideo < ActiveRecord::Base
	 #For youtube video embedding
  	auto_html_for :video_link do
    	html_escape
    	image
    	youtube(width: 400, height: 250, autoplay: false)
    	link target: "_blank", rel: "nofollow"
    end
end
