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
  
  def get_label_in_scope(t,l)
    languages = t.counterplayers(:atype => @base_locator+"/association/scoping", :rtype=>@base_locator+"/types/named_topic_type", :otype => @base_locator+"/types/language" )
    labels = t.counterplayers(:atype => @base_locator+"/association/scoping", :rtype=>@base_locator+"/types/named_topic_type", :otype => @base_locator+"/types/displaylabel" )
    namedlabels = languages.zip(labels);
    namedlabel = "";
    for label in namedlabels
      if  label[0]["-label"].first.value == l["-label"].frst.value
        namedlabel = label[1]["-label"].first.value
        break
      end
    end
    return namedlabel;
  end
  
  def create_label_in_scope(label,l,t)
    #type = @tm.get(@base_locator + "/types/displaylabel")
    topic = @tm.get!(@base_locator + "/instances/labels/" + label)
    topic.add_type(@base_locator + "/types/displaylabel")
    topic["-label"] = label
    asso = @tm.get(@base_locator + "/association/scoping")    
    asso.cr t.si.first.value, @base_locator + "/types/named_topic_type"
    asso.cr topic ,  @base_locator + "/types/displaylabel"
    asso.cr l.si.first.value ,  @base_locator + "/types/language"
  end
  
end
