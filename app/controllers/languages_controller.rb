class LanguagesController < ApplicationController
  private
  def topicType
    return @base_locator + "/types/language" 
  end
  
  public
  
  def index
    @languages = @tm.get(topicType).instances
    if (@languages.size < 1)
      redirect_to products_url 
    end
  end
  
  def show
    @id = params[:id].to_i
    @language = @tm.topic_by_id(@id)
    if (@tm.get(topicType).instances.include?(@language))
    else
      redirect_to languages_url
    end
  end
  
  def create        
    redirect_to(language_url(createTopic(params).id))   
  end
  
  def update
    
  end
  
  
end
