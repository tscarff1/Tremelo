class BandVideo < ActiveRecord::Base
  validates :video_link, presence: true
  validates :video_name, presence: true

 #For youtube video embedding
	auto_html_for :video_link do
  	html_escape
  	image
  	youtube(width: 400, height: 250, autoplay: false)
  	link target: "_blank", rel: "nofollow"
  end

end
