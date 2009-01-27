# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def get_image_tag(t)
    images = t[@base_locator+"/types/image"]
    if images.size > 0
      return "<img src=\"" + images.first.value + "\" />"
    else
      return "<img src=\"../images/nopic.png\" />"
    end
  end

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

  #this method returns the default label
  def get_default_label(t)
    arg = (t[@base_locator+"/types/label"].first)?(t[@base_locator+"/types/label"].first):(t["-"].first)
    if arg
      return arg.value
    else
      return "Unknown"
    end
  end

end
