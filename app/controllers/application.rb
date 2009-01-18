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
  #before_filter :generate_db_from_xtm2
  
  protected
  def set_tm
    @base_locator = "http://moebelportal.topicmapslab.de"
    @tm = RTM[@base_locator]
  end
  
<<<<<<< local
=======
  def generate_db_from_xtm2
    @base_locator = "http://moebelportal.topicmapslab.de"
    RTM.connect_sqlite3("db/development.sqlite3")
    RTM.generate_database
    #@tm = RTM.from_xtm2lx(File.open("./Model/ikeatm.xtm2"), @base_locator)
    #if !(@tm)
      @tm = RTM.from_xtm2(File.open("./Model/ikeatm.xtm2"), @base_locator)
    #end
  end
  
>>>>>>> other
end
