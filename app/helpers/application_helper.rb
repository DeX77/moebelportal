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
  
end
