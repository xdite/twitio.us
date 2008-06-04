require('rubygems')
gem('twitter4r', '0.3.0')
require('twitter')
class AccountController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem
  # If you want "remember me" functionality, add this before_filter to Application Controller
  before_filter :login_from_cookie

  # say something nice, you goof!  something sweet.
  def index
    redirect_to(:action => 'signup') unless logged_in? || User.count > 0
  end

  def zzzlogin
    return unless request.post?
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(:controller => '/account', :action => 'index')
      flash[:notice] = "Logged in successfully"
    end
  end


  def login
    @login_user = User.new(params[:user])
    return unless request.post?
    @login_temp_name = @login_user.login
    @login_temp_pass = @login_user.password

    client = Twitter::Client.new(:login => @login_temp_name ,:password => @login_temp_pass )
    begin	
    if client.authenticate?(@login_temp_name, @login_temp_pass) == true 
	#if twitter login success

       begin
# get twitter user's infomation
        
        @twitinfo = client.my(:info)
        rescue Twitter::RESTError
             @twitinfo = client.timeline_for(:me).first.user
	rescue
#         if cant get information
	  render :action => 'login'
       end

       if User.find_by_twid(@twitinfo.id)
#        find_user_by_twid success
         self.current_user = User.find_by_twid(@twitinfo.id) 
 	self.current_user.login = @twitinfo.screen_name
         self.current_user.profile_image_url = @twitinfo.profile_image_url
         self.current_user.twurl = @twitinfo.url
         self.current_user.description = @twitinfo.description
         self.current_user.location = @twitinfo.location
	 self.current_user.tw_password =  @login_temp_pass
         self.current_user.save

       elsif User.find_by_login(@login_temp_name)
#        find_user_by_login_temp_name

         self.current_user = User.find_by_login(@login_temp_name)
         self.current_user.login = @twitinfo.screen_name
         self.current_user.twid = @twitinfo.id
         self.current_user.profile_image_url = @twitinfo.profile_image_url
         self.current_user.twurl = @twitinfo.url
         self.current_user.description = @twitinfo.description
         self.current_user.location = @twitinfo.location
         self.current_user.tw_password =  @login_temp_pass
         self.current_user.save
       else
#        cant find anything
         if User.find_by_login(@twitinfo.screen_name)
         self.current_user = User.find_by_login(@twitinfo.screen_name)
         self.current_user.twid = @twitinfo.id
         self.current_user.profile_image_url = @twitinfo.profile_image_url
         self.current_user.twurl = @twitinfo.url
         self.current_user.description = @twitinfo.description
         self.current_user.location = @twitinfo.location
         self.current_user.tw_password =  @login_temp_pass
         self.current_user.save
         else
         @login_user.login = @twitinfo.screen_name
         @login_user.twid = @twitinfo.id
         @login_user.profile_image_url = @twitinfo.profile_image_url
         @login_user.twurl = @twitinfo.url
         @login_user.description = @twitinfo.description
         @login_user.location = @twitinfo.location
	 @login_user.tw_password =  @login_temp_pass
         @login_user.save!
         self.current_user = User.find_by_twid(@twitinfo.id)
         end
                   
       end

#       login redirect
#       if params[:remember_me] == "1"
#        self.current_user.remember_me
#           cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
#       end

       session[:twpw] = @login_temp_pass 
       if (session[:return_to]) !=nil 
         redirect_to(session[:return_to])
       else
 	 redirect_to :controller => "twits",:action => "index"
       end 
    else
#    if twitter login fail
      render :action => 'login'
    end    

    rescue Twitter::RESTError
       redirect_to :controller => "account",:action => "login_fail"
    end
				       
    rescue ActiveRecord::RecordInvalid
      render :action => 'login'
  end 
  def tsignup
    @user = User.new(params[:user])
    return unless request.post?
    @user.save!
    self.current_user = @user
    redirect_back_or_default(:controller => '/account', :action => 'index')
    flash[:notice] = "Thanks for signing up!"
  rescue ActiveRecord::RecordInvalid
    render :action => 'signup'
  end
  
  def logout
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "You have been logged out."
    redirect_back_or_default(:controller => '/twits', :action => 'index')
  end
end
