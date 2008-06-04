class RssController < ApplicationController

  def twits
    @headers["Content-Type"] = "application/xml"
    @twits = Twit.find(:all,:order => 'id DESC', :limit => "30")
    render :layout => false
  end

end
