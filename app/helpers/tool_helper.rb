module ToolHelper
<<<<<<< local
=======

   def get_image_tag(t)
      images = t[@base_locator+"/types/image"]
      if images.size > 0
        return "<img src=\"" + images.first.value + "\" />"
      else
        return "<img src=\"../images/nopic.png\" />"
      end
    end

   def list_labels(t)
      languages = t.counterplayers(:atype => @base_locator+"/association/scoping", :rtype=>@base_locator+"/types/named_topic_type", :otype => @base_locator+"/types/language" )
      labels = t.counterplayers(:atype => @base_locator+"/association/scoping", :rtype=>@base_locator+"/types/named_topic_type", :otype => @base_locator+"/types/displaylabel" )
      namedlabels = languages.zip(labels);
      html = "";
      for label in namedlabels
        html += label[1]["-"].first.value
        html += "(" + label[0]["-"].first.value + ")"
        html += "<br />"
      end
      return html;
   end

>>>>>>> other
end
