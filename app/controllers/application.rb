# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '3b738bc4b681d4917a93d2ee84a0351a'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  before_filter :set_tm
  
  protected
  def set_tm
    @tm = RTM[0]
  end
  
  def generate_db_from_xtm2
    RTM.connect
    RTM.generate_database
    @tm = RTM.from_xtm2lx(File.open("./Model/ikeatm.xtm2"), "http://www.uni-leipzig.de/tmp/ikea")
  end
  
end
