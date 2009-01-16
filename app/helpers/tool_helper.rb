module ToolHelper

   def get_image_tag(t)
      images = t[@base_locator+"/types/image"]
      if images.size > 0
        return "<img src=\"" + images.first.value + "\" />"
      else
        return "No pic avaible"
      end
    end

end
