require('rubygems')
gem('twitter4r', '0.3.0')
require('twitter')
require 'open-uri'
class TwitsController < ApplicationController
layout "twits", :except => [:new,:go]
before_filter :login_required, :only => [:new,:go,:success]
  def go
    new
    render :action => 'new'
  end
  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }
  def popular
     @twits = Twit.find_by_sql("SELECT url, count( url ) AS count FROM twits WHERE (created_at >  '#{2.days.ago.to_s(:db)}') group by url ORDER BY count DESC LIMIT 15")
  end  
	 
  def index
     list
     render :action => "list" 
  end  
  def list
    @twit_pages, @twits = paginate :twits, :per_page => 25, :order => "id DESC"
    case params[:status]
    when '1'
    @twit_pages, @twits = paginate :twits, :per_page => 25, :order => "id DESC",:conditions => "type_id =1"
    when '2'
    @twit_pages, @twits = paginate :twits, :per_page => 25, :order => "id DESC",:conditions => "type_id =2"
    when '3'
    @twit_pages, @twits = paginate :twits, :per_page => 25, :order => "id DESC",:conditions => "type_id =3"
    when '4'
    @twit_pages, @twits = paginate :twits, :per_page => 25, :order => "id DESC",:conditions => "type_id =4"
    when '5'
    @twit_pages, @twits = paginate :twits, :per_page => 25, :order => "id DESC",:conditions => "type_id =5"
    when '6'
    @twit_pages, @twits = paginate :twits, :per_page => 25, :order => "id DESC",:conditions => "type_id =6"
    when '7'
    @twit_pages, @twits = paginate :twits, :per_page => 25, :order => "id DESC",:conditions => "type_id =7"
    when '8'
    @twit_pages, @twits = paginate :twits, :per_page => 25, :order => "id DESC",:conditions => "type_id =8"
    when '9'
    @twit_pages, @twits = paginate :twits, :per_page => 25, :order => "id DESC",:conditions => "type_id =9"
    when '10'
    @twit_pages, @twits = paginate :twits, :per_page => 25, :order => "id DESC",:conditions => "type_id =10"
    when '11'
    @twit_pages, @twits = paginate :twits, :per_page => 25, :order => "id DESC",:conditions => "type_id =11"
    else
    end

  end

  def show
    @twit = Twit.find(params[:id])
  end

  def new
    @twit = Twit.new
    @twit.url = params[:url]
    @twit.title = params[:title]
  end

  def create
    @twit = Twit.new(params[:twit])
    @dtype = Dtype.new(params[:dtype])

    client = Twitter::Client.new(:login => current_user.login ,:password => current_user.tw_password)

    begin	
       @twit.tinyurl = open("http://tinyurl.com/api-create.php?url="+@twit.url).read(200)
    rescue
    end  
    case @twit.type_id
       when -1
         @post_string = @dtype.dtype_name+" \""+@twit.title+"\" ("+@twit.tinyurl+")"
	 if @twit.comment.length>1
	 @post_string = @post_string+"#"+take_nchars(@twit.comment,100)
	 end
         @success = client.status(:post, @post_string)
         
       else
         @post_string = Type.find(@twit.type_id).type_name+":"+" \""+@twit.title+"\" ("+ @twit.tinyurl+")"
	 if @twit.comment.length>1
         @post_string = @post_string+" # "+ take_nchars(@twit.comment,100)
	 end
         @success = client.status(:post, @post_string)
       end

    if @success
       if @twit.save

           case @twit.type_id
           when -1
              @dtype.twit_id = @twit.id
              @dtype.user_id = @twit.user_id
              @dtype.save
           else
           end
           flash[:notice] = 'Twit was successfully created.'
           redirect_to :action => "success"
        else
        render :action => 'new'
        end
      else
        render :action => 'new'
      end
  end
  protected 

  def take_nchars(str,n)
	str.slice(/\A.{0,#{n}}/m)
  end
end
