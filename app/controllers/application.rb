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
  before_filter :authorize, :except =>[:index, :show, :index_json, :switch]
  
  protected
  
  def authorize
    unless admin?
      flash[:error] = "Poeser Pursche!!"
      redirect_to root_url
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

  def set_lang
    @current_lang = find_language("de")
  end
  
  def destroy
    #Topic Nummer
    @id = params[:id].to_i
    #Aktuelles Topic
    @topic = @tm.topic_by_id(@id)
    @tm.destroy(@topic)    
  end
  
  def update_name(topic, name)
    topic[@base_locator+ "/types/label"] = name
  end
  
  def update_image(topic, image_url)
    topic[@base_locator+ "/types/image"] = image_url
  end
  
  def update_description(topic, description)
    topic[@base_locator+ "/types/description"] = description
  end
  
  def createTopic(params)
    topic_tmp = params[:topic]
    number_tmp = topic_tmp[:number]
    name_tmp = topic_tmp[:name]
    image_tmp = topic_tmp[:image]
    description_tmp = topic_tmp[:description]
    
    puts "SI: " + get_Instance_from_Number(number_tmp)
    new_topic = @tm.get!(get_Instance_from_Number(number_tmp))
    update_name(new_topic, name_tmp)
    update_image(new_topic, image_tmp)    
    update_description(new_topic, description_tmp)
    new_topic.add_type(topicType)
    
    return new_topic
  end
  
  def updateTopic(params)
    number_tmp = topic_tmp[:number]
    name_tmp = topic_tmp[:name]
    image_tmp = topic_tmp[:image]
    description_tmp = topic_tmp[:description]
    
    updated_topic = @tm.get_by_id(params[:id])
    update_name(updated_topic, name_tmp)
    update_image(updated_topic, image_tmp)    
    update_description(updated_topic, description_tmp)
    
    return new_topic
  end

  def instanceLabels(topicType)
    @instances = @tm.get(topicType).instances
    @result = Array.new
    
    @instances.each do |instance|
      labels = instance.counterplayers(:atype => @base_locator+"/association/scoping", :rtype=>@base_locator+"/types/named_topic_type", :otype => @base_locator+"/types/displaylabel" )
      if !labels.empty?
        @result << labels.join
        next
      else      
        basename = instance["-"].first
        if basename
          @result << basename.value
          next
        else
          defaultlabel = instance[@base_locator + "/types/label"].first
          if defaultlabel
            @result << defaultlabel.value
            next
          end
        end
      end
    end
    
    return @result
  end
  
  def labelsIncluding(instanceLabels, text)
    blah = instanceLabels.select() do |label|
      label.include? text
    end
  end

  #this method create a new label in diven language
  def create_label_in_scope(params)
    topic_tmp = params[:topic]
    lang_tmp = topic_tmp[:lang]
    label_tmp = topic_tmp[:label]

    topic = @tm.topic_by_id(params[:id])

    new_topic = @tm.get!(params[:id] + "_" + lang_tmp )
    update_name(new_topic, label_tmp)
    #todo so richtig???
    new_topic.add_type(tm.get(@base_locator + "/types/displaylabel"))

    lang = @tm.get_by_id(lang_tmp)

    asso = @tm.get(@base_locator + "/association/scoping")
    asso.cr topic, @base_locator + "/types/named_topic_type"
    asso.cr new_topic ,  @base_locator + "/types/displaylabel"
    asso.cr lang,  @base_locator + "/types/language"
  end

   def find_language(label_)
    @langs = @tm.get(@base_locator +"/types/language").instances
    for lang in @langs
      label = lang["-"].first
      if label && label.value.include?(label_)
        return lang
      end
    end
    return nil
  end

  public

   def switch
    @current_lang = @tm.topic_by_id(params[:id].to_i)
  end

  def index_json
    render :json => labelsIncluding(instanceLabels(topicType), params[:id])
  end  
end
