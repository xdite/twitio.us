class UserTwitController < ApplicationController


   def index
      @user = User.find_by_login(params[:login])
      @twit_pages, @twits = paginate :twits, :conditions => "user_id = #{@user.id}", :order => "id DESC",:per_page => 25
   end

   def rss
      @user = User.find_by_login(params[:login])
      @headers["Content-Type"] = "application/xml"
      @twits = Twit.find(:all,:conditions => "user_id = #{@user.id}",:order => 'id DESC', :limit => "30")
      render :layout => false
   end

end
