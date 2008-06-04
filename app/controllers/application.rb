# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  # Pick a unique cookie name to distinguish our session data from others'
  session :session_key => '_twitthat_session_id'
    include AuthenticatedSystem
    before_filter :login_from_cookie

    before_filter :configure_charsets
    def configure_charsets
    @response.headers["Content-Type"] = "text/html; charset=utf-8"
    suppress(ActiveRecord::StatementInvalid) do
    ActiveRecord::Base.connection.execute 'SET NAMES UTF8'
    end
    end



end
