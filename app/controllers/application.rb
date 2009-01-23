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
  before_filter :authorize, :except =>[:index, :show]  
  
  protected
  
  def authorize
    unless admin?
      flash[:error] = "Poeser Pursche!!"
      redirect_to home_url
      false
    end
  end
  
  def admin?
    current_user.admin?
  end
  
  def get_Instance_from_Number(number)
    @base_locator = "http://moebelportal.topicmapslab.de"
    return @base_locator + "/instances/" + number
  end
  
  def set_tm
    @base_locator = "http://moebelportal.topicmapslab.de"
    @tm = RTM[@base_locator]
  end
  
  
  def destroy
    #Topic Nummer
    @id = params[:id].to_i
    #Aktuelles Topic
    @topic = @tm.topic_by_id(@id)
    @tm.destroy(@topic)    
  end
  
  def createTopic(params)
    topic_tmp = params[:topic]
    number_tmp = topic_tmp[:number]
    name_tmp = topic_tmp[:name]
    image_tmp = topic_tmp[:image]
    description_tmp = topic_tmp[:description]
    
    puts "SI: " + get_Instance_from_Number(number_tmp)
    new_topic = @tm.get!(get_Instance_from_Number(number_tmp))
    new_topic[@base_locator+ "/types/label"] = name_tmp
    new_topic[@base_locator+ "/types/image"] = image_tmp
    new_topic[@base_locator+ "/types/description"] = description_tmp
    new_topic.add_type(topicType)
    
    return new_topic
  end
  
end
