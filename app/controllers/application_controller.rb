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
  before_filter :authorize_reporter, :only =>[:edit, :update, :new, :create, :view_translate]
  
  protected
  
  #this method fetch die display label of a topic by the current language if it exists
  def get_label(t)
    labels = t.counterplayers(:atype => @base_locator+"/association/scoping", :rtype=>@base_locator+"/types/named_topic_type", :otype => @base_locator+"/types/displaylabel" )
    for label in labels
      if $current_lang
        return get_label_in_scope(t,$current_lang)
      else
        return get_default_label(label)
      end
    end
    return get_default_label(t)
  end
  
  #this method returns the label of the topic in given scope
  def get_label_in_scope(t,l)
    @lang_ = get_default_label(l)
    languages = t.counterplayers(:atype => @base_locator+"/association/scoping", :rtype=>@base_locator+"/types/named_topic_type", :otype => @base_locator+"/types/language" )
    labels = t.counterplayers(:atype => @base_locator+"/association/scoping", :rtype=>@base_locator+"/types/named_topic_type", :otype => @base_locator+"/types/displaylabel" )
    namedlabels = languages.zip(labels)
    namedlabel = get_default_label(t)
    for label in namedlabels
      if  get_default_label(label[0]).include?(@lang_)
        namedlabel = get_default_label(label[1])
        break
      end
    end
    return namedlabel;
  end
  
  def check_translation(t)
    @lang_ = get_default_label(l)
    languages = t.counterplayers(:atype => @base_locator+"/association/scoping", :rtype=>@base_locator+"/types/named_topic_type", :otype => @base_locator+"/types/language" )
    labels = t.counterplayers(:atype => @base_locator+"/association/scoping", :rtype=>@base_locator+"/types/named_topic_type", :otype => @base_locator+"/types/displaylabel" )
    namedlabels = languages.zip(labels)
    namedlabel = false
    for label in namedlabels
      if  get_default_label(label[0]).include?(@lang_)
        namedlabel = true
        break
      end
    end
    return namedlabel;
  end
  
  #this method returns the default label
  def get_default_label(t)
    arg = (t[@base_locator+"/types/label"].first)?(t[@base_locator+"/types/label"].first):(t["-"].first)
    if arg
      return arg.value
    else
      return "Unknown"
    end
  end
  
  def authorize_admin
    unless admin?
      flash[:error] = "Need Login"
      redirect_to root_url
      false
    end
  end
  
  def authorize_reporter
    unless (reporter? || admin?)
      flash[:error] = "Need Login"
      redirect_to root_url
      false
    end
  end
  
  
  def admin?
    if (!session[:user])
      return false
    end
    
    groups = @tm.get(@base_locator + "/types/usergroup").instances
    
    groups.each() do |group|
      if (get_default_label(group).include? "admins")
        adminGroup = group
        admins = adminGroup.counterplayers(:atype => @base_locator+"/association/membership", :rtype => @base_locator+"/role/group")
        
        admins.each() do |admin|
          if (get_default_label(group).include? session[:user])
            return true
          end
        end
        return false
      end
    end
    
  end
  
  def reporter?
    if (!session[:user])
      return false
    end
    
    groups = @tm.get(@base_locator + "/types/usergroup").instances
    reporterGroup = ""
    
    groups.each() do |group|
      if (get_default_label(group).include? "reporters")
        reporterGroup = group
        reporters = reporterGroup.counterplayers(:atype => @base_locator+"/association/membership", :rtype => @base_locator+"/role/group")
        
        reporters.each() do |reporter|
          if (get_default_label(reporter).include? session[:user])
            return true
          end
        end
        return false
        
      end
    end
    
  end
  
  
  def get_Instance_from_Number(number)
    @base_locator = "http://moebelportal.topicmapslab.de"
    return @base_locator + "/instances/" + number
  end
  
  def set_tm
    @base_locator = "http://moebelportal.topicmapslab.de"
    @tm = RTM[@base_locator]
    if $current_lang == nil
      set_lang
    end
  end
  
  def set_lang
    $current_lang = find_language("de")
  end
  
  def destroy
    #Topic Nummer
    @id = params[:id].to_i
    #Aktuelles Topic
    @topic = @tm.topic_by_id(@id)
    @tm.destroy(@topic)    
  end
  
  def update_name(topic, name)
    puts "Update name zu:" + name
     if topic[@base_locator+ "/types/label"].first
       topic[@base_locator+ "/types/label"].first.value = name
     else
       topic[@base_locator+ "/types/label"] = name
     end
  end
  
  def update_image(topic, image_url)
    puts "Update image_url zu:" + image_url    
    if topic[@base_locator+ "/types/image"].first
      topic[@base_locator+ "/types/image"].first.value = image_url
    else
      topic[@base_locator+ "/types/image"] = image_url
    end
  end
  
  def update_description(topic, description)
    puts "Update description zu:" + description.join(" ")    
    if topic[@base_locator+ "/types/description"].first
      topic[@base_locator+ "/types/description"].first.value = description
    else
      topic[@base_locator+ "/types/description"] = description
    end
  end
  
  def createTopic(params)
    number_tmp = params[:si]
    name_tmp = params[:label]
    image_tmp = params[:image_occ]
    description_tmp = params[:desc]
    
    puts "SI: " + get_Instance_from_Number(number_tmp)
    new_topic = @tm.get!(get_Instance_from_Number(number_tmp))
    update_name(new_topic, name_tmp)
    update_image(new_topic, image_tmp)    
    update_description(new_topic, description_tmp)
    new_topic.add_type(topicType)
    
    return new_topic.id
  end
  
  def updateTopic(params)
    name_tmp = params[:label]
    image_tmp = params[:image_occ]
    description_tmp = params[:desc]
    
    updated_topic = @tm.topic_by_id(params[:id])
    if (!name_tmp.empty?)
      update_name(updated_topic, name_tmp)
    end
    
    if (!image_tmp.empty?)
      update_image(updated_topic, image_tmp)
    end
    
    if (!description_tmp.join(" ").empty?)
      update_description(updated_topic, description_tmp)
    end
    
    return updated_topic.id
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
    instanceLabels.select() do |label|
      label.include? text
    end
  end
  
  #this method create a new label in diven language
  def set_label_in_scope(id,t,label)
    
    @subI = get_Instance_from_Number(id + "_" + get_default_label($current_lang))
    @new_topic = @tm.get!(@subI)
    update_name(@new_topic, label)
    @new_topic.add_type(@tm.get(@base_locator + "/types/displaylabel"))
    
    create_association_ex(@base_locator + "/association/scoping", t, @base_locator + "/types/named_topic_type", @new_topic, @base_locator + "/types/displaylabel", $current_lang, @base_locator + "/types/language")
    
    
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
  
  def create_association(typeAssociation,player1,typePlayer1,player2,typePlayer2)
    if player1.si.first && player2.si.first
      asso = @tm.create_association(typeAssociation)
      asso.cr player1.si.first.value, typePlayer1
      asso.cr player2.si.first.value, typePlayer2
    end
  end
  
  def create_association_ex(typeAssociation,player1,typePlayer1,player2,typePlayer2,player3,typePlayer3)
    if player1.si.first && player2.si.first && player3.si.first
      asso = @tm.create_association(typeAssociation)
      asso.cr player1.si.first.value, typePlayer1
      asso.cr player2.si.first.value, typePlayer2
      asso.cr player3.si.first.value, typePlayer3
    end
  end
  
  public
  
  def switch
    $current_lang = @tm.topic_by_id(params[:id].to_i)
  end
  
  def index_json
    render :json => labelsIncluding(instanceLabels(topicType), params[:id])
  end
  
  def new
    @type = topicType
    @nummer = "Nr"
    @image ="ImageURL"
    @topic = @tm.get!("")
    @image = "Description"
  end
  
  def edit
    #ID aus Request
    @id = params[:id].to_i
    @type = topicType
    @topic = @tm.topic_by_id(@id)
    @nummer = @topic.si
    imageOcc = @topic[@base_locator+"/types/image"]
    descOcc = @topic[@base_locator+"/types/description"]
    
    if (imageOcc)
      imageOcc = imageOcc.first
      if (imageOcc)
        @image = imageOcc.value
      end
    end
    
    if (descOcc)
      descOcc = descOcc.first
      if (descOcc)
        @description = descOcc.value
      end
    end
    
    
  end
  
  def update
    redirect_to :action => "show", :id => updateTopic(params)
  end
  
  def create        
    redirect_to  :action => "show", :id => createTopic(params)   
  end
  
  
  
  def set_translation
    @id = params[:id].to_i
    @topic = @tm.topic_by_id(@id)
    
    @label = params[:label]
    
    set_label_in_scope(params[:id],@topic,@label)
    
    redirect_to :action => "index"
  end
  
  
  def view_translate
    @id = params[:id].to_i
    @topic = @tm.topic_by_id(@id)
    @label = get_default_label(@topic)
  end

  def index_json_search
    @text = params[:id];
    @result = Array.new

    @products = @tm.get(@base_locator + "/types/product").instances
    for product in @products
      @label = get_label(product)
      if @label.include?(@text)
        @result  << "p:" + product.id.to_s + ":" + @label
      end
    end

    @manuals = @tm.get(@base_locator + "/types/manual").instances
    for manual in @manuals
      @label = get_label(manual)
      if @label.include?(@text)
        @result  << "m:" + manual.id.to_s + ":" + @label
      end
    end

    @steps= @tm.get(@base_locator + "/types/step").instances
    for step in @steps
      @label = get_label(step)
      if @label.include?(@text)
        @result  << "s:" + step.id.to_s + ":" + @label
      end
    end

    @tools = @tm.get(@base_locator + "/types/tool").instances
    for tool in @tools
      @label = get_label(tool)
      if @label.include?(@text)
        @result  << "t:" + tool.id.to_s + ":" + @label
      end
    end

    @materials = @tm.get(@base_locator + "/types/material").instances
    for material in @materials
      @label = get_label(material)
      if @label.include?(@text)
        @result  << "e:" + material.id.to_s + ":" + @label
      end
    end

    render :json => @result
  end

end
